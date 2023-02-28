//
//  PostViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 28.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol CommentDelegate: AnyObject {
    func didTapComment()
    func didTapLike(for cell: PostTableViewCell)
}
class PostTableViewCell: UITableViewCell {
    
    weak var delegate: CommentDelegate?
    var commentArray = [String]()
    
    lazy var authorImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 50/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var postImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameAuthor: UILabel = {
        let name = UILabel()
        name.textColor = UIColor.createColor(light: .white, dark: .white)
        name.shadowColor = .black
        name.font = .systemFont(ofSize: 15, weight: .bold)
        name.shadowOffset = CGSize(width: 1, height: 1)
        name.clipsToBounds = true
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .clear
        return name
    }()
    
    lazy var descriptionText: UILabel = {
        let name = UILabel()
        name.numberOfLines = 0
        name.textColor = UIColor.createColor(light: .white, dark: .white)
        name.shadowColor = .black
        name.font = .systemFont(ofSize: 14, weight: .thin)
        name.shadowOffset = CGSize(width: 1, height: 1)
        name.layer.shadowOpacity = 1
        name.layer.shadowRadius = 30
        name.layer.cornerRadius = 3
        name.clipsToBounds = true
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var datePost: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 12, weight: .light)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .systemGray5
        name.backgroundColor = .clear
        return name
    }()
    
    lazy var commentCountLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 13, weight: .light)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .systemGray5
        name.text = "Комментарии"
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapComment))
        name.addGestureRecognizer(gesture)
        name.isUserInteractionEnabled = true
        name.backgroundColor = .clear
        return name
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "bubble.right.circle.fill@100x"), for: .normal)
        button.addTarget(self, action: #selector(tapComment), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapLike() {
        delegate?.didTapLike(for: self)
    }
    
    @objc func tapComment() {
        delegate?.didTapComment()
    }
    
    func constraints() {
         [authorImage, nameAuthor, postImage, commentButton, likeButton, descriptionText, commentCountLabel, datePost].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            authorImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            authorImage.heightAnchor.constraint(equalToConstant: 50),
            authorImage.widthAnchor.constraint(equalToConstant: 50),
            
            nameAuthor.centerYAnchor.constraint(equalTo: authorImage.centerYAnchor),
            nameAuthor.leadingAnchor.constraint(equalTo: authorImage.trailingAnchor,constant: 10),
            
            postImage.topAnchor.constraint(equalTo: authorImage.bottomAnchor,constant: 10),
            postImage.heightAnchor.constraint(lessThanOrEqualToConstant: 600),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            
            commentButton.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 10),
            commentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            commentButton.heightAnchor.constraint(equalToConstant: 30),
            commentButton.widthAnchor.constraint(equalToConstant: 30),
            
            likeButton.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor,constant: 10),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            
            descriptionText.topAnchor.constraint(equalTo: commentButton.bottomAnchor,constant: 20),
            descriptionText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            commentCountLabel.topAnchor.constraint(equalTo: descriptionText.bottomAnchor,constant: 10),
            commentCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            
            datePost.topAnchor.constraint(equalTo: commentCountLabel.bottomAnchor,constant: 10),
            datePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            datePost.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureTable(post: Post?) {
        guard let authorImageUrl = post?.user.picture else { return }
        guard let postImageUrl = post?.imageUrl else { return }
        DispatchQueue.main.async {
            self.authorImage.loadImage(urlString: authorImageUrl)
        }
        self.nameAuthor.text = post?.user.username
        self.datePost.text = post?.creationDate.timeAgoDisplay()
            
        let attributedText = NSMutableAttributedString(string: post?.user.username ?? "")
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: NSRange(location: 0, length: post?.user.username.count ?? 0))
        let attributeComment = NSAttributedString(string: "  \(post?.message ?? "")")
        attributedText.append(attributeComment)
        self.descriptionText.attributedText = attributedText
        
        postImage.loadImage(urlString: postImageUrl)
        likeButton.setBackgroundImage(post?.hasLiked == true ? UIImage(named: "heart.circle.fill@100x") : UIImage(systemName: "heart.circle.fill"), for: .normal)
    }
}
