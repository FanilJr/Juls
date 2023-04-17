//
//  PhotosCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    let image: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemGray
        image.image = UIImage(named: "Grey_full")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        [image].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    func configureCell(post: Post?) {
        image.image = UIImage(named: "Grey_full")
        guard let imageURL = post?.imageUrl else { return }
        self.image.loadImage(urlString: imageURL)
    }
}
