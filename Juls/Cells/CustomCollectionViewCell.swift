//
//  CustomCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var user: User?
    var post: Post? {
        didSet {
            guard let imageURL = post?.imageUrl else { return }
            image.loadImage(urlString: imageURL)
        }
    }
    
    let image: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        
        addSubview(image)
        layer.cornerRadius = 14
        clipsToBounds = true

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configurePhotos(post: Post?) {
        guard let imageUrl = post?.imageUrl else { return }
        image.loadImage(urlString: imageUrl)
    }
    
    func pullCell(photo: UIImage) {
        image.image = photo
    }
}

