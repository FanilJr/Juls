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
    
    var message: Message? {
        didSet {
            guard let message = message else { return }
            self.updateLastMessage(message: message)
        }
    }
    
    let profileImageView: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 60/2
        pi.clipsToBounds = true
        pi.image = UIImage(named: "Grey_full")
        pi.backgroundColor = .gray
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    let usernameLabel: UILabel = {
        let user = UILabel()
        user.translatesAutoresizingMaskIntoConstraints = false
        return user
    }()
    
    let lastMessage: UILabel = {
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    let dateMassage: UILabel = {
        let message = UILabel()
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
    
    func updateLastMessage(message: Message) {
        self.lastMessage.text = message.text
        self.dateMassage.text = message.creationDate.timeAgoDisplay()
        self.profileImageView.loadImage(urlString: message.user.picture)
        self.usernameLabel.text = message.user.username
        
        if message.isRead {
            self.usernameLabel.font = UIFont(name: "Futura", size: 14)
            self.lastMessage.font = UIFont.systemFont(ofSize: 13)
            self.dateMassage.font = UIFont(name: "Futura", size: 10)
        } else {
            self.usernameLabel.font = UIFont(name: "Futura-Bold", size: 15)
            self.lastMessage.font = UIFont.boldSystemFont(ofSize: 14)
            self.dateMassage.font = UIFont(name: "Futura-Bold", size: 11)
        }
    }
    
    func constraints() {
        [profileImageView, usernameLabel,lastMessage, dateMassage].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -52),
            
            lastMessage.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            lastMessage.widthAnchor.constraint(equalToConstant: 225),
            lastMessage.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            dateMassage.centerYAnchor.constraint(equalTo: lastMessage.centerYAnchor),
            dateMassage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
        ])
    }
}
