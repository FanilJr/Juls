//
//  FollowersUserViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 30.01.2023.
//

import Foundation
import UIKit

class FollowersUserViewController: UIViewController {
    
//    var filteredUsers = [User]()
    var usersArray = [User]()
//    var users = [User]()
//    var post = [Post]()
    let juls = JulsView()
    var refreshControler = UIRefreshControl()
    
    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Enter username"
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
        tableView.register(FollowersUserViewCell.self, forCellReuseIdentifier: "FollowersUserViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = juls
        layout()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        navigationController?.navigationBar.isHidden = false
        print(usersArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        searchController.searchBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    static func show(_ viewController: UIViewController, users: [User]) {
        let ac = FollowersUserViewController()
        ac.usersArray = users
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
    
    @objc func didTapRefresh() {
//        self.users.removeAll()
//        self.filteredUsers.removeAll()
        self.refreshControler.endRefreshing()
//        self.fetchUsers()
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

extension FollowersUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersUserViewCell", for: indexPath) as! FollowersUserViewCell
        cell.backgroundColor = .clear
        cell.configureTable(user: usersArray[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = usersArray[indexPath.item]
        let user = usersArray[indexPath.row]
        ProfileFriendsViewController.show(self, user: user)
        searchController.searchBar.isHidden = true
        searchController.searchBar.resignFirstResponder()
    }
}

extension FollowersUserViewController: UITableViewDelegate {
    
}

extension FollowersUserViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchText.isEmpty {
//            usersArray = users
//        } else {
//            self.usersArray = self.users.filter { user -> Bool in
//                return user.username.lowercased().contains(searchText.lowercased())
//            }
//        }
//        self.tableView.reloadData()
    }
}


