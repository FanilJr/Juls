//
//  FollowersUserViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 30.01.2023.
//

import Foundation
import UIKit
import Firebase

class MyFollowersUserViewController: UIViewController {
    
    var user: User?
    var users: [User] = []
    var filteredUsers: [User] = []
    var refreshControler = UIRefreshControl()
    
    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "search people"
        return search
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = UIColor.createColor(light: .black, dark: .white)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControler
        tableView.register(MyFollowersUserViewCell.self, forCellReuseIdentifier: "MyFollowersUserViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWillAppear()
    }
    
    private func setupDidLoad() {
        title = "Подписки"
        layout()
        view.backgroundColor = .systemBackground
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        fetchUsers()
        waitingSpinnerEnable(activity: self.spinnerView, active: true)
    }
    
    private func setupWillAppear() {
        searchController.searchBar.isHidden = false
        searchController.searchBar.resignFirstResponder()
        navigationItem.searchController = searchController
    }
    
    func fetchUsers() {
        guard let uid = user?.uid else { return }
        Database.database().getUsersIFollow(myUserId: uid) { users in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.users = users
                self.filteredUsers = users
                waitingSpinnerEnable(activity: self.spinnerView, active: false)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func didTapRefresh() {
        fetchUsers()
    }
    
    func layout() {
        [tableView,spinnerView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinnerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

extension MyFollowersUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFollowersUserViewCell", for: indexPath) as! MyFollowersUserViewCell
        cell.backgroundColor = .clear
        cell.configureTable(user: filteredUsers[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
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

extension MyFollowersUserViewController: UITableViewDelegate {
    
}

extension MyFollowersUserViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            self.filteredUsers = self.users.filter { user -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

