//
//  NewsTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var autorName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleName: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionName: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ model: Article) {
        autorName.text = model.author
        titleName.text = model.title
        descriptionName.text = model.description
    }
    
    private func constraints() {
        [titleName, descriptionName].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleName.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            titleName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            titleName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            
            descriptionName.topAnchor.constraint(equalTo: titleName.bottomAnchor,constant: 16),
            descriptionName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 14),
            descriptionName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -14),
            descriptionName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
}

