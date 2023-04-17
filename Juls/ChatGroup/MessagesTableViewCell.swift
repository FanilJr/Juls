//
//  MessagesTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 24.02.2023.
//

import Foundation
import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    let profileImageView: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 80/2
        pi.clipsToBounds = true
        pi.image = UIImage(named: "Black")
        pi.backgroundColor = .gray
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    let usernameLabel: UILabel = {
        let user = UILabel()
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
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -42)
            
        ])
    }
    
    func configureTable(user: User?) {
        profileImageView.image = UIImage(named: "Black")
        guard let profileImageUrl = user?.picture else { return }
        if profileImageUrl == "" {
            self.profileImageView.image = UIImage(named: "noimage")
        } else {
            profileImageView.loadImage(urlString: profileImageUrl)
        }
        usernameLabel.text = user?.username
    }
}
