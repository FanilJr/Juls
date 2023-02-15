//
//  SearchController.swift
//  Juls
//
//  Created by Fanil_Jr on 06.01.2023.
//

import Foundation
import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    var filteredUsers = [User]()
    var users = [User]()
    var experimentUser = [User]()
    var post = [Post]()
    let juls = JulsView()
    var refreshControler = UIRefreshControl()
    
    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "search people"
        return search
    }()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControler
        tableView.register(CellIdTableViewCell.self, forCellReuseIdentifier: "CellIdTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = juls
        navigationItem.searchController = searchController
        layout()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        self.fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.users.removeAll()
//        self.fetchUsers()
        navigationController?.navigationBar.isHidden = false
        searchController.searchBar.isHidden = false
    }
    
    @objc func didTapRefresh() {
        self.users.removeAll()
        self.filteredUsers.removeAll()
        self.experimentUser.removeAll()
        self.fetchUsers()
    }

    func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.tableView.refreshControl?.endRefreshing()
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
    
    func fetchPostsWithUser(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { key, value in
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.post.append(post)
            }
            self.post.sort { p1, p2 in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
            self.tableView.reloadData()
            print("Перезагрузка в ProfileFriendsViewController fetchPostWithUser")
        }) { error in
            print("Failed to fetch posts:", error)
            return
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experimentUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdTableViewCell", for: indexPath) as! CellIdTableViewCell
        cell.backgroundColor = .clear
        cell.configureTable(user: experimentUser[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = experimentUser[indexPath.item]
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        if myUserId == user.uid {
            print("hello myUser")
        } else {
            let profileVcUser = ProfileViewController(viewModel: ProfileViewModel())
            profileVcUser.userId = user.uid
            navigationController?.pushViewController(profileVcUser, animated: true)
            searchController.searchBar.isHidden = true
            searchController.searchBar.resignFirstResponder()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            experimentUser = []
        } else {
            self.experimentUser = self.users
            self.experimentUser = self.users.filter { user -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}


