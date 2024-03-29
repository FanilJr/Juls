//
//  LocalChatWithUserTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 11.03.2023.
//

import Foundation
import UIKit
import Firebase

class LocalChatWithUserTableViewCell: UITableViewCell {
    
    var messages: Message? {
        didSet {
            guard let userImage = messages?.user.picture else { return }
            profileImageView.loadImage(urlString: userImage)
            nameCommentUser.text = messages?.user.username
            descriptionNameandText.text = messages?.text
            timeAgo.text = messages?.creationDate.timeAgoDisplay()
        }
    }
    
    var viewForBack: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.createColor(light: .systemGray6, dark: .systemPurple)
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 30/2
        pi.clipsToBounds = true
        pi.backgroundColor = .gray
        pi.isUserInteractionEnabled = true
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    let descriptionNameandText: UILabel = {
        let descriptionNameandText = UILabel()
        descriptionNameandText.numberOfLines = 0
        descriptionNameandText.font = UIFont.systemFont(ofSize: 15)
        descriptionNameandText.translatesAutoresizingMaskIntoConstraints = false
        return descriptionNameandText
    }()
    
    let nameCommentUser: UILabel = {
        let nameCommentUser = UILabel()
        nameCommentUser.font = UIFont.systemFont(ofSize: 13)
        nameCommentUser.translatesAutoresizingMaskIntoConstraints = false
        return nameCommentUser
    }()
    
    let timeAgo: UILabel = {
        let timeAgo = UILabel()
        timeAgo.font = UIFont.systemFont(ofSize: 10)
        timeAgo.translatesAutoresizingMaskIntoConstraints = false
        return timeAgo
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        [profileImageView,viewForBack,descriptionNameandText].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            
            viewForBack.topAnchor.constraint(equalTo: descriptionNameandText.topAnchor,constant: -7),
            viewForBack.leadingAnchor.constraint(equalTo: descriptionNameandText.leadingAnchor,constant: -12),
            viewForBack.trailingAnchor.constraint(equalTo: descriptionNameandText.trailingAnchor,constant: 12),
            viewForBack.bottomAnchor.constraint(equalTo: descriptionNameandText.bottomAnchor,constant: 7),
            
            descriptionNameandText.topAnchor.constraint(equalTo: profileImageView.topAnchor,constant: 6),
            descriptionNameandText.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 16),
            descriptionNameandText.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            descriptionNameandText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -7),
        ])
    }
}

