//
//  AllChatsTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 09.03.2023.
//

import Foundation
import UIKit
import Firebase

class AllChatsTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.picture else { return }
            if profileImageUrl == "" {
                self.profileImageView.image = UIImage(named: "noimage")
            } else {
                DispatchQueue.main.async {
                    self.profileImageView.loadImage(urlString: profileImageUrl)
                }
            }
            usernameLabel.text = user?.username
            guard let officialUser = user else { return }
            fetchLastMessage(user: officialUser)
        }
    }
    
    let profileImageView: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 80/2
        pi.clipsToBounds = true
        pi.backgroundColor = .gray
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    let usernameLabel: UILabel = {
        let user = UILabel()
        user.font = UIFont.boldSystemFont(ofSize: 14)
        user.translatesAutoresizingMaskIntoConstraints = false
        return user
    }()
    
    let lastMessage: UILabel = {
        let message = UILabel()
        message.font = UIFont.systemFont(ofSize: 12)
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    let dateMassage: UILabel = {
        let message = UILabel()
        message.font = UIFont.systemFont(ofSize: 10)
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchLastMessage(user: User) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchMessageWithChatId(userUID: uid, userFriendUID: user.uid) { messages in
            guard let last = messages.last?.text else { return }
            self.lastMessage.text = last
        }
        
        Database.database().fetchMessageWithChatId(userUID: uid, userFriendUID: user.uid) { date in
            guard let date = date.last?.creationDate.timeAgoDisplay() else { return }
            self.dateMassage.text = date
        }
    }
    
    func constraints() {
        [profileImageView, usernameLabel,lastMessage, dateMassage].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -72),
            
            lastMessage.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            lastMessage.widthAnchor.constraint(equalToConstant: 230),
            lastMessage.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            dateMassage.centerYAnchor.constraint(equalTo: lastMessage.centerYAnchor),
            dateMassage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
        ])
    }
}
