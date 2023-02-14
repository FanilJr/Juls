//
//  CommentsTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 11.02.2023.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    let profileImageView: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 30/2
        pi.clipsToBounds = true
        pi.backgroundColor = .gray
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    let descriptionNameandText: UILabel = {
        let descriptionNameandText = UILabel()
        descriptionNameandText.numberOfLines = 0
        descriptionNameandText.font = UIFont.systemFont(ofSize: 12)
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
        [profileImageView, nameCommentUser, timeAgo, descriptionNameandText].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 7),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            
            nameCommentUser.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 3),
            nameCommentUser.heightAnchor.constraint(equalToConstant: 20),
            nameCommentUser.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            
            timeAgo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            timeAgo.centerYAnchor.constraint(equalTo: nameCommentUser.centerYAnchor),

            descriptionNameandText.topAnchor.constraint(equalTo: nameCommentUser.bottomAnchor),
            descriptionNameandText.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,constant: 10),
            descriptionNameandText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -30),
            descriptionNameandText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
        ])
    }
    
    func configureComments(comment: Comment) {
        profileImageView.loadImage(urlString: comment.user.picture)
        descriptionNameandText.text = comment.text
        nameCommentUser.text = comment.user.username
        timeAgo.text = comment.creationDate.timeAgoDisplay()
    }
}
