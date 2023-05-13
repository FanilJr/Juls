//
//  ContactsMessageViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 09.03.2023.
//

import Foundation
import UIKit
import Firebase

protocol ContactsDelegate: AnyObject {
    func dismisAndPushChat(user: User)
}

class ContactsMessagesViewController: UIViewController {
    
    weak var delegate: ContactsDelegate?
    var filteredUsers = [User]()
    var users = [User]()
    var experimentUser = [User]()
    var post = [Post]()

    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: "MessagesTableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupDidLoad() {
        view.backgroundColor = .systemBackground
        title = "Сообщения"
        layout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        fetchUsersIFollow()
    }
    
    func fetchUsersIFollow() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().getUsersIFollow(myUserId: uid) { users in
            DispatchQueue.main.async {
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
    }
}

extension ContactsMessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        cell.backgroundColor = .clear
        cell.configureTable(user: filteredUsers[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        delegate?.dismisAndPushChat(user: user)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Подписки"
    }
}

extension ContactsMessagesViewController: UITableViewDelegate {

}


