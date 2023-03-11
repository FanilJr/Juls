//
//  MessagesViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 24.02.2023.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {
    
    var user: User?
    var users = [User]()
    var filteredUsers = [User]()
    var post = [Post]()
    let juls = JulsView()
    var chats: String?
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
        tableView.register(AllChatsTableViewCell.self, forCellReuseIdentifier: "AllChatsTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.isHidden = false
        
        let height = self.tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y += height!
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let height = self.tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y -= height!
        }
    }
    
    private func setupDidLoad() {
        setupNavButton()
        view.backgroundColor = .systemBackground
        title = "Сообщения"
        navigationItem.searchController = searchController
        layout()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        fetchAllMessages()
    }
    
    func fetchAllMessages() {
        guard let uid = user?.uid else { return }
        Database.database().fetchAllMessages(userUID: uid) { users in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func didTapRefresh() {
        self.fetchAllMessages()
    }

    func setupNavButton() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addContact))
        addButton.tintColor = UIColor.createColor(light: .black, dark: .white)
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addContact() {
        let contactMessagesVC = ContactsMessagesViewController()
        contactMessagesVC.delegate = self
        navigationController?.present(contactMessagesVC, animated: true)
    }
    
    func layout() {
        [tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MessagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllChatsTableViewCell", for: indexPath) as! AllChatsTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let chatWithUserVC = ChatViewController()
        chatWithUserVC.userFriend = user
        chatWithUserVC.user = self.user
        self.navigationController?.pushViewController(chatWithUserVC, animated: true)
    }
}

extension MessagesViewController: UITableViewDelegate {
    
}

extension MessagesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            print(searchText)
        } else {
           filteredUsers = users.filter { user -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}

extension MessagesViewController: ContactsDelegate {
    
    func dismisAndPushChat(user: User) {
        self.dismiss(animated: true)
        let chatWithUserVC = ChatViewController()
        chatWithUserVC.userFriend = user
        chatWithUserVC.user = self.user
        self.navigationController?.pushViewController(chatWithUserVC, animated: true)
    }
}


