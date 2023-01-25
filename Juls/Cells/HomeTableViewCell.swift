//
//  RibbonTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 12.01.2023.
//

import UIKit
import Firebase

class HomeTableViewCell: UITableViewCell {

    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            postImage.loadImage(urlString: postImageUrl)
            guard let authorImageUrl = post?.user.picture else { return }
            authorImage.loadImage(urlString: authorImageUrl)
            nameAuthor.text = post?.user.username
            descriptionText.text = post?.message
            nameAuthorForComment.text = (post?.user.username)! + ":"
        }
    }
    
    lazy var authorImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50/2
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var blure: UIVisualEffectView = {
        let bluereEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blure = UIVisualEffectView()
        blure.effect = bluereEffect
        blure.translatesAutoresizingMaskIntoConstraints = false
        blure.clipsToBounds = true
        return blure
    }()
    
    lazy var nameAuthor: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var nameAuthorForComment: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var descriptionText: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 14, weight: .light)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var postImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        [blure, authorImage, nameAuthor, postImage, nameAuthorForComment, descriptionText].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            blure.topAnchor.constraint(equalTo: contentView.topAnchor),
            blure.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blure.heightAnchor.constraint(equalToConstant: 70),
            blure.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            authorImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            authorImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            authorImage.heightAnchor.constraint(equalToConstant: 50),
            authorImage.widthAnchor.constraint(equalToConstant: 50),
            
            nameAuthor.centerYAnchor.constraint(equalTo: authorImage.centerYAnchor),
            nameAuthor.leadingAnchor.constraint(equalTo: authorImage.trailingAnchor,constant: 10),
            
            postImage.topAnchor.constraint(equalTo: authorImage.bottomAnchor,constant: 10),
            postImage.heightAnchor.constraint(equalTo: contentView.widthAnchor,constant: 100),
            postImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            nameAuthorForComment.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 20),
            nameAuthorForComment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            nameAuthorForComment.widthAnchor.constraint(equalToConstant: 90),
            nameAuthorForComment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
            
            descriptionText.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 20),
            descriptionText.leadingAnchor.constraint(equalTo: nameAuthorForComment.trailingAnchor,constant: 10),
            descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            descriptionText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20)
        ])
    }
}

