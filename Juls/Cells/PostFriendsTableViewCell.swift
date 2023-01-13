//
//  PostFriendsTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 11.01.2023.
//

import UIKit

class PostFriendsTableViewCell: UITableViewCell {

    var post: Post? {
        
        didSet {
            self.descriptionText.text = post?.message
            guard let imageUrl = post?.imageUrl else { return }
            postImage.loadImage(urlString: imageUrl)
        }
    }
    
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
        [postImage, descriptionText].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImage.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            postImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            descriptionText.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 20),
            descriptionText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20)
        ])
    }
}
