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
    
    var usersKeyFollowMe = [String]()
    var countUserFollowMe = [String]()
    var user: User?
    var filteredUsers = [User]()
    var users = [User]()
    let juls = JulsView()
    var refreshControler = UIRefreshControl()
    let dispatchMain = DispatchQueue.main
    
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
        tableView.register(FollowersUserWithMeCell.self, forCellReuseIdentifier: "FollowersUserWithMeCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        title = "Подписчики"
        layout()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag

        checkFollowMeKeys(user: user!) { massive in
            self.checkCountKeys(item: massive) { item in
                self.ktoImennoKeys(item: item)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.isHidden = false
        searchController.searchBar.resignFirstResponder()
        navigationController?.navigationBar.isHidden = false
        navigationItem.searchController = searchController
    }
    
    static func show(_ viewController: UIViewController, users: [User]) {
        let ac = FollowersUsersWithMeController()
        ac.users = users
        
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
    
    static func showUsers(_ viewController: UIViewController, user: User) {
        let ac = FollowersUsersWithMeController()
        ac.user = user
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
    
    @objc func didTapRefresh() {
        
        self.refreshControler.endRefreshing()
        
        checkFollowMeKeys(user: user!) { massive in
            self.checkCountKeys(item: massive) { item in
                DispatchQueue.main.async {
                    self.ktoImennoKeys(item: item)
                }
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
        ProfileFriendsViewController.show(self, user: user)
        searchController.searchBar.isHidden = true
        searchController.searchBar.resignFirstResponder()
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

extension FollowersUsersWithMeController {
 
    func checkFollowMeKeys(user: User?, completion: @escaping ([String]) -> ()) {
        dispatchMain.async {
            guard let userId = user?.uid else { return }
            let ref = Database.database().reference().child("following")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard let iFollowUsers = snapshot.value as? [String: Any] else { return }
                iFollowUsers.forEach { key, value in
                    if key != userId {
                        var massive = [String]()
                        massive.append(key)
                        completion(massive)
                    }
                }
            })
        }
    }
    
    func checkCountKeys(item: [String], completion: @escaping ([String]) -> ()) {
        for i in item {
            dispatchMain.async {
                let ref = Database.database().reference().child("following").child(i)
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    guard let usersCountFollowMe = snapshot.value as? [String: Any] else { return }
                    usersCountFollowMe.forEach { key, value in
                        if key == self.user?.uid {
                            var massive = [String]()
                            massive.append(i)
                            completion(massive)
                        }
                    }
                })
            }
        }
    }
    
    func ktoImennoKeys(item: [String]) {
        self.users = []
        self.filteredUsers = []
        for i in item {
            dispatchMain.async {
                let ref = Database.database().reference().child("users")
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let dictionaries = snapshot.value as? [String: Any] else { return }
                    
                    dictionaries.forEach { key, value in
                        if key == i {
                            guard let userDictionary = value as? [String: Any] else { return }
                            let user = User(uid: key, dictionary: userDictionary)
                            self.users.append(user)
                            self.filteredUsers = self.users
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
}
