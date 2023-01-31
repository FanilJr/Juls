//
//  PhotosCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    lazy var blureForCell: UIVisualEffectView = {
        let bluereEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blure = UIVisualEffectView()
        blure.effect = bluereEffect
        blure.translatesAutoresizingMaskIntoConstraints = false
        blure.clipsToBounds = true
        blure.layer.cornerRadius = 14
        return blure
    }()
    
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
        
        [blureForCell, image].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            blureForCell.topAnchor.constraint(equalTo: topAnchor),
            blureForCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            blureForCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            blureForCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        layer.cornerRadius = 14
        clipsToBounds = true
    }
    
    func configureCell(post: Post?) {
        guard let imageURL = post?.imageUrl else { return }
        image.loadImage(urlString: imageURL)
    }
}
