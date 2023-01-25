//
//  PhotosCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit


class PhotosCollectionViewCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageURL = post?.imageUrl else { return }
            image.loadImage(urlString: imageURL)
        }
    }
    
    let image: CustomImageView = {
        let image = CustomImageView()
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
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        layer.cornerRadius = 14
        clipsToBounds = true
    }
 

}
