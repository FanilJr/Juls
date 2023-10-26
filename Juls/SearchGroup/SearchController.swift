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
        tableView.register(CellIdTableViewCell.self, forCellReuseIdentifier: "CellIdTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.isHidden = false
    }
    
    private func setupDidLoad() {
        view.backgroundColor = .systemBackground
        title = "Поиск"
        navigationItem.searchController = searchController
        addDelegate()
    }
    
    func addDelegate() {
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        settingsTable()
    }
    
    func settingsTable() {
        let refreshControler = UIRefreshControl()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        tableView.refreshControl = refreshControler
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        layout()
    }
    
    @objc func didTapRefresh() {
        self.fetchUsers()
    }

    func fetchUsers() {
        Database.database().feetchUsersForSearch { users in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.users = users
                self.filteredUsers = users
                self.tableView.reloadData()
            }
        }
    }
    
    func layout() {
        [tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        fetchUsers()
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


