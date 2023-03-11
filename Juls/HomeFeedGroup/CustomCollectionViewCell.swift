//
//  CustomCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 11.03.2023.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var image: UIImageView = {
        let image = UIImageView()
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
    
    func setupCell() {
        addSubview(image)
        layer.cornerRadius = 92/2
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupStorys(photo: UIImage) {
        image.image = photo
    }
}
