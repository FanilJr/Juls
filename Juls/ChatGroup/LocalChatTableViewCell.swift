//
//  LocalChatTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 09.03.2023.
//

import Foundation
import UIKit
import Firebase

class LocalChatTableViewCell: UITableViewCell {
    
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
        view.backgroundColor = UIColor.createColor(light: #colorLiteral(red: 0.4501784879, green: 0.7874124858, blue: 0.9391061802, alpha: 1), dark: .systemBlue)
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 30/2
        pi.clipsToBounds = true
        pi.backgroundColor = .gray
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    lazy var chatImage: CustomImageView = {
        let pi = CustomImageView()
        pi.contentMode = .scaleAspectFill
        pi.layer.cornerRadius = 20
        pi.clipsToBounds = true
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
    
    let readLabel: UILabel = {
        let readLabel = UILabel()
        readLabel.numberOfLines = 0
        readLabel.font = UIFont.systemFont(ofSize: 12)
        readLabel.translatesAutoresizingMaskIntoConstraints = false
        return readLabel
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
        [profileImageView,viewForBack,descriptionNameandText,readLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            
            viewForBack.topAnchor.constraint(equalTo: descriptionNameandText.topAnchor,constant: -7),
            viewForBack.leadingAnchor.constraint(equalTo: descriptionNameandText.leadingAnchor,constant: -12),
            viewForBack.trailingAnchor.constraint(equalTo: descriptionNameandText.trailingAnchor,constant: 12),
            viewForBack.bottomAnchor.constraint(equalTo: descriptionNameandText.bottomAnchor,constant: 7),
            
            descriptionNameandText.topAnchor.constraint(equalTo: profileImageView.topAnchor,constant: 5),
            descriptionNameandText.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor,constant: -16),
            descriptionNameandText.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            
            readLabel.topAnchor.constraint(equalTo: viewForBack.bottomAnchor),
            readLabel.trailingAnchor.constraint(equalTo: viewForBack.trailingAnchor),
            readLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
    }
}
