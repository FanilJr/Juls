//
//  FollowersUsersWithMe.swift
//  Juls
//
//  Created by Fanil_Jr on 01.02.2023.
//

import Foundation
import UIKit
import Firebase

class FollowersUsersWithMeController: UIViewController {
    
    var user: User?
    var filteredUsers = [User]()
    var users = [User]()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = UIColor.createColor(light: .black, dark: .white)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
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
        tableView.register(FollowersUserWithMeCell.self, forCellReuseIdentifier: "FollowersUserWithMeCell")
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
        view.backgroundColor = .systemBackground
        title = "Подписчики"
        waitingSpinnerEnable(activity: self.spinnerView, active: true)
        navigationSettings()
    }
    
    private func setupWillAppear() {
        searchController.searchBar.isHidden = false
        searchController.searchBar.resignFirstResponder()
        navigationItem.searchController = searchController
    }
    
    func navigationSettings() {
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
    
    
    func fetchUsers() {
        guard let uid = user?.uid else { return }
        Database.database().getUsersFollowMe(myUserId: uid) { users in
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
            
            spinnerView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            spinnerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        ])
        fetchUsers()
    }
}

extension FollowersUsersWithMeController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersUserWithMeCell", for: indexPath) as! FollowersUserWithMeCell
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

extension FollowersUsersWithMeController: UITableViewDelegate {
    
}

extension FollowersUsersWithMeController: UISearchBarDelegate {
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
