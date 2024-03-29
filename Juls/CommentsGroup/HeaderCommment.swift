//
//  HeaderCommment.swift
//  Juls
//
//  Created by Fanil_Jr on 11.02.2023.
//

import UIKit

class HeaderCommment: UIView {

    var post: Post? {
        didSet {
            guard let imageUrl = post?.user.picture else { return }
            authorImage.loadImage(urlString: imageUrl)
            nameAuthor.text = post?.user.username
            datePost.text = post?.creationDate.timeAgoDisplay()
            
            let attributedText = NSMutableAttributedString(string: post?.user.username ?? "")
            attributedText.addAttribute(.font, value: UIFont(name: "Futura-Bold", size: 14)!, range: NSRange(location: 0, length: post?.user.username.count ?? 0))
            let attributeComment = NSAttributedString(string: "  \(post?.message ?? "")")
            attributedText.append(attributeComment)
            
            descriptionText.attributedText = attributedText
        }
    }
    
    lazy var authorImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameAuthor: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "Futura-Bold", size: 17)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .clear
        return name
    }()
    
    lazy var descriptionText: UILabel = {
        let name = UILabel()
        name.numberOfLines = 0
        name.textColor = UIColor.createColor(light: .white, dark: .white)
        name.shadowColor = .black
        name.font = UIFont(name: "Futura", size: 16)
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
        name.font = UIFont(name: "Futura", size: 14)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .systemGray5
        name.backgroundColor = .clear
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        [authorImage,descriptionText,datePost].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            authorImage.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            authorImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            authorImage.heightAnchor.constraint(equalToConstant: 100),
            authorImage.widthAnchor.constraint(equalToConstant: 100),
            
            descriptionText.topAnchor.constraint(equalTo: authorImage.bottomAnchor,constant: 20),
            descriptionText.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            descriptionText.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            datePost.topAnchor.constraint(equalTo: descriptionText.bottomAnchor,constant: 10),
            datePost.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            datePost.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10)
        ])
    }
}
