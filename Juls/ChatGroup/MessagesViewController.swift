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
    var messages = [Message]()
    var filteredMessage = [Message]()
    var cgfloatTabBar: CGFloat?
    var refreshControler = UIRefreshControl()
    
    lazy var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addContact))
    lazy var filteredButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(filteredUnRead))
    lazy var removeFilterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), style: .plain, target: self, action: #selector(removeFilter))
    
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
        
        if self.tabBarController?.tabBar.frame.origin.y != self.cgfloatTabBar {
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.frame.origin.y += height!
            }
        }
    }
    
    private func setupDidLoad() {
        setupNavButton()
        fetchAllMessages()
        view.backgroundColor = .systemBackground
        title = "Сообщения"
        navigationItem.searchController = searchController
        waitingSpinnerEnable(activity: self.spinnerView, active: true)
        layout()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        addButton.tintColor = UIColor.createColor(light: .black, dark: .white)
        
        let height = self.tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y += height!
            self.cgfloatTabBar = self.tabBarController?.tabBar.frame.origin.y
        }
    }
    
    func fetchAllMessages() {
        guard let uid = user?.uid else { return }
        
        Database.database().fetchLastMessagesInMessenger(userUID: uid) { message in
            DispatchQueue.main.async {
                self.filteredMessage = message
                self.messages = message
                waitingSpinnerEnable(activity: self.spinnerView, active: false)
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    @objc func didTapRefresh() {
        self.fetchAllMessages()
    }

    func setupNavButton() {
        navigationItem.rightBarButtonItems = [addButton,filteredButton]
    }
    
    @objc func filteredUnRead() {
        title = "Непрочитанное"
        navigationItem.rightBarButtonItems = [addButton,removeFilterButton]
        filteredMessage = messages.filter { messages -> Bool in
            return messages.isRead == false
        }
        self.tableView.reloadData()
    }
    
    @objc func removeFilter() {
        title = "Сообщения"
        navigationItem.rightBarButtonItems = [addButton,filteredButton]
        filteredMessage = messages
        self.tableView.reloadData()
    }
    
    @objc func addContact() {
        let contactMessagesVC = ContactsMessagesViewController()
        contactMessagesVC.delegate = self
        navigationController?.present(contactMessagesVC, animated: true)
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

extension MessagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllChatsTableViewCell", for: indexPath) as! AllChatsTableViewCell
        cell.backgroundColor = .clear
        cell.message = filteredMessage[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredMessage[indexPath.row].user
        let chatWithUserVC = ChatViewController()
        chatWithUserVC.userFriend = user
        chatWithUserVC.lastMessage = filteredMessage[indexPath.row].text
        chatWithUserVC.user = self.user
        
        self.navigationController?.pushViewController(chatWithUserVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let messageIndex = filteredMessage[indexPath.row].user.uid
        Database.database().removeChatWithAllChats(userUID: uid, userFriendWithDeleteUID: messageIndex) { error in
            if let error {
                print(error)
                return
            }
            print("remove chat with:", self.filteredMessage[indexPath.row].user.username)
            self.filteredMessage.remove(at: indexPath.item)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        tableView.endUpdates()
    }
}

extension MessagesViewController: UITableViewDelegate {
    
}

extension MessagesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredMessage = messages
        } else {
            filteredMessage = messages.filter { messages -> Bool in
               return messages.user.username.lowercased().contains(searchText.lowercased())
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
