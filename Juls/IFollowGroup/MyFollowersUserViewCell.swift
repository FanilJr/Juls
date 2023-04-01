//
//  FollowersUserViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 30.01.2023.
//

import Foundation
import UIKit
import Firebase

class MyFollowersUserViewCell: UITableViewCell {
    
    let profileImageView: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 60/2
        pi.image = UIImage(named: "Grey_full")
        pi.clipsToBounds = true
        pi.backgroundColor = .gray
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    let usernameLabel: UILabel = {
        let user = UILabel()
        user.text = "username"
        user.font = UIFont(name: "Futura-Bold", size: 14)
        user.translatesAutoresizingMaskIntoConstraints = false
        return user
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        [profileImageView, usernameLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -32)
        ])
    }
    
    func configureTable(user: User?) {
        guard let profileImageUrl = user?.picture else { return }
        if profileImageUrl == "" {
            self.profileImageView.image = UIImage(named: "noimage")
        } else {
            DispatchQueue.main.async {
                self.profileImageView.loadImage(urlString: profileImageUrl)
            }
        }
        guard let uid = user?.uid else { return }
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        if uid == myUid {
            usernameLabel.text = "Я"
        } else {
            usernameLabel.text = user?.username
        }
    }
}
