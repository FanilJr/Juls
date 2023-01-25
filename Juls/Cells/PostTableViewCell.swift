//
//  PostTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

class PostTableViewCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            descriptionText.text = post?.message
            guard let imageUrl = post?.imageUrl else { return }
            postImage.loadImage(urlString: imageUrl)
            guard let authorImageUrl = post?.user.picture else { return }
            authorImage.loadImage(urlString: authorImageUrl)
            nameAuthor.text = post?.user.username
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
    
    lazy var descriptionText: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var postImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
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
        [blure, authorImage, nameAuthor, postImage, descriptionText].forEach { contentView.addSubview($0) }
        
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
            
            descriptionText.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 20),
            descriptionText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20)
        ])
    }
}
