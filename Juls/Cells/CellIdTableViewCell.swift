//
//  CellIdTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 06.01.2023.
//

import UIKit

class CellIdTableViewCell: UITableViewCell {
    
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
        user.text = "username"
        user.font = UIFont.boldSystemFont(ofSize: 14)
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
//            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -42)
            
        ])
    }
    
    func configureTable(user: User?) {
        guard let profileImageUrl = user?.picture else { return }
        if profileImageUrl == "" {
            self.profileImageView.image = UIImage(named: "noimage")
        } else {
            profileImageView.loadImage(urlString: profileImageUrl)
        }
        usernameLabel.text = user?.username
    }
}
