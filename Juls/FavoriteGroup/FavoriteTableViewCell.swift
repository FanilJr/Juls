//
//  FavoriteTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

//import Foundation
//import UIKit
//
//class FavoriteTableViewCell : UITableViewCell {
//    
//    //MARK: create labels
//    private var authorCells: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private var descriptionCells: UILabel = {
//        let label = UILabel()
//        label.textColor = .gray
//        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private var imageCells: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    private var likesCells: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 16.0)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private var viewsCells: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 16.0)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    //MARK: Initial cells
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        layout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: Приравние структурных ячеек к созданным ячейкам
//    
//    public func myCells(_ post: PostData) {
//        self.authorCells.text = post.authorCell ?? ""
////        self.imageCells.image = UIImage(named: post.imageCell!) ?? UIImage()
//    }
//    
//    //MARK: Initial constraints
//    func layout() {
//        
//        [authorCells, imageCells].forEach { contentView.addSubview($0) }
//        
//        NSLayoutConstraint.activate([
//            authorCells.topAnchor.constraint(equalTo: contentView.topAnchor),
//            authorCells.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
//            authorCells.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            authorCells.heightAnchor.constraint(equalToConstant: 50),
//            
//            imageCells.topAnchor.constraint(equalTo: authorCells.bottomAnchor),
//            imageCells.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageCells.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageCells.heightAnchor.constraint(equalToConstant: 400),
//            imageCells.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -28)
//        ])
//    }
//}

