//
//  SearchController.swift
//  Juls
//
//  Created by Fanil_Jr on 06.01.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    var filteredUsers = [User]()
    var users = [User]()
    let juls = JulsView()
    
    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Enter username"
        return search
    }()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "sunset")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(CellIdTableViewCell.self, forCellReuseIdentifier: "CellIdTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = juls
        layout()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        searchController.searchBar.isHidden = false
        tableView.reloadData()
        print("reaload SearchTable")
    }

    func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { key, value in
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            }
            self.filteredUsers = self.users
            self.tableView.reloadData()
        }) { err in
            print("Failed to fetch users", err)
        }
    }
    
    func layout() {
        [background, tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: background.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
        ])
        
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdTableViewCell", for: indexPath) as! CellIdTableViewCell
        cell.backgroundColor = .clear
        cell.user = filteredUsers[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        ProfileFriendsViewController.show(self, user: user)
        searchController.searchBar.isHidden = true
        searchController.searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            self.filteredUsers = self.users.filter { user -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}


