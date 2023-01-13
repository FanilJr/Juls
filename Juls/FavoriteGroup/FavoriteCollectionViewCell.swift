//
//  FavoriteCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

//import UIKit
//
//class FavoriteCollectionViewCell: UICollectionViewCell {
//    
//    let image: UIImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFill
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCell()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupCell() {
//        
//        addSubview(image)
//        layer.cornerRadius = 14
//        clipsToBounds = true
//
//        NSLayoutConstraint.activate([
//            image.topAnchor.constraint(equalTo: topAnchor),
//            image.leadingAnchor.constraint(equalTo: leadingAnchor),
//            image.trailingAnchor.constraint(equalTo: trailingAnchor),
//            image.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//    
//    public func myCells(_ post: PostData) {
//        self.image.image = UIImage(data: post.imageCell!)
//    }
//}

