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
    
    var usersKeyIFollow = [String]()
    var user: User?
    var users: [User] = []
    var filteredUsers: [User] = []
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
        tableView.register(MyFollowersUserViewCell.self, forCellReuseIdentifier: "MyFollowersUserViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        title = "Подписки"
        layout()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag

        guard let user = user else { return }
        getKeyIFollowUser(user: user) { key in
            self.getUsersIFollow(keys: key)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.isHidden = false
        searchController.searchBar.resignFirstResponder()
        navigationController?.navigationBar.isHidden = false
        navigationItem.searchController = searchController
    }
    
//    static func show(_ viewController: UIViewController, users: [User]) {
//        let ac = MyFollowersUserViewController()
//        ac.users = users
//        
//        viewController.navigationController?.pushViewController(ac, animated: true)
//    }
//    
//    static func showUsers(_ viewController: UIViewController, user: User) {
//        let ac = MyFollowersUserViewController()
//        ac.user = user
//        viewController.navigationController?.pushViewController(ac, animated: true)
//    }
    
    @objc func didTapRefresh() {
        guard let user = user else { return }
        getKeyIFollowUser(user: user) { key in
            DispatchQueue.main.async {
                self.users.removeAll()
                self.getUsersIFollow(keys: key)
            }
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
        self.tableView.reloadData()
    }
}

extension MyFollowersUserViewController {
    
    func getKeyIFollowUser(user: User, completion: @escaping ([String]) -> ()) {
        DispatchQueue.main.async {
            let ref = Database.database().reference().child("following").child(user.uid)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                self.tableView.refreshControl?.endRefreshing()
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                dictionaries.forEach { key, value in
                    if key == user.uid {
                        return
                    }
                    var massiveKey = [String]()
                    massiveKey.append(key)
                    completion(massiveKey)
                }
            })
        }
    }
    
    func getUsersIFollow(keys: [String]) {
        for i in keys {
            DispatchQueue.main.async {
                let ref = Database.database().reference().child("users")
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let dictionaries = snapshot.value as? [String: Any] else { return }
                    
                    dictionaries.forEach { key, value in
                        
                        if key == i {
                            guard let userDictionary = value as? [String: Any] else { return }
                            
                            let user = User(uid: key, dictionary: userDictionary)
                            self.users.append(user)
                        }
                        self.filteredUsers = self.users
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
}


