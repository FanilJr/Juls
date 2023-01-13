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
        }
    }
    
    lazy var authorImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameAuthor: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var descriptionText: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var postImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        [authorImage, nameAuthor, postImage, descriptionText].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            authorImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            authorImage.heightAnchor.constraint(equalToConstant: 50),
            authorImage.widthAnchor.constraint(equalToConstant: 50),
            
            nameAuthor.centerYAnchor.constraint(equalTo: authorImage.centerYAnchor),
            nameAuthor.leadingAnchor.constraint(equalTo: authorImage.trailingAnchor,constant: 10),
            
            postImage.topAnchor.constraint(equalTo: authorImage.bottomAnchor,constant: 10),
            postImage.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            postImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            descriptionText.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 20),
            descriptionText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20)
        ])
    }
}

