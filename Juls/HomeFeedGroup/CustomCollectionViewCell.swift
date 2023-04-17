//
//  CustomCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 11.03.2023.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var rating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.createColor(light: .systemPurple, dark: .systemPurple)
        label.shadowColor = UIColor.createColor(light: .black, dark: .black)
        label.font = UIFont(name: "Futura-Bold", size: 11)
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    var imagePople: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "Black")
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var kingImage: UIImageView = {
        let king = UIImageView()
        king.image = UIImage(named: "crown")
        king.translatesAutoresizingMaskIntoConstraints = false
        king.contentMode = .scaleAspectFill
        king.tintColor = .yellow
        king.alpha = 0.0
        return king
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        [imagePople].forEach{ addSubview($0) }
        [kingImage,rating].forEach { imagePople.addSubview($0) }
        
        NSLayoutConstraint.activate([
            imagePople.topAnchor.constraint(equalTo: topAnchor),
            imagePople.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagePople.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagePople.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rating.bottomAnchor.constraint(equalTo: imagePople.bottomAnchor,constant: -5),
            rating.trailingAnchor.constraint(equalTo: imagePople.trailingAnchor,constant: -5),
            
            kingImage.topAnchor.constraint(equalTo: imagePople.topAnchor,constant: 3),
            kingImage.leadingAnchor.constraint(equalTo: imagePople.leadingAnchor,constant: 5),
            kingImage.heightAnchor.constraint(equalToConstant: 15),
            kingImage.widthAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    func setupPeople(user: User) {
        imagePople.image = UIImage(named: "Black")
        imagePople.loadImage(urlString: user.picture)
        rating.text = "\(user.rating)"
    }
}
