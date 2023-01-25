//
//  ArticleTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

protocol URLDelegate: AnyObject {
    func tapInURL()
}

class ArticleTableViewCell: UITableViewCell {
    
    var delegate: URLDelegate?
        
    lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleName: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var url: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionName: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buttonURL: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(tapURL), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapURL() {
        delegate?.tapInURL()
    }
    
    private func constraints() {
        [date, progress, postImage, titleName, descriptionName, url, buttonURL].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 14),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            
            postImage.topAnchor.constraint(equalTo: date.bottomAnchor,constant: 14),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            postImage.heightAnchor.constraint(equalToConstant: 200),
            
            progress.centerYAnchor.constraint(equalTo: postImage.centerYAnchor),
            progress.centerXAnchor.constraint(equalTo: postImage.centerXAnchor),
            progress.widthAnchor.constraint(equalToConstant: 100),
            progress.heightAnchor.constraint(equalToConstant: 5),
            
            titleName.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 5),
            titleName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            titleName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            
            descriptionName.topAnchor.constraint(equalTo: titleName.bottomAnchor,constant: 16),
            descriptionName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 14),
            descriptionName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -14),
            
            url.topAnchor.constraint(equalTo: descriptionName.bottomAnchor,constant: 16),
            url.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 14),
            url.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -14),
            url.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            buttonURL.centerYAnchor.constraint(equalTo: url.centerYAnchor),
            buttonURL.centerXAnchor.constraint(equalTo: url.centerXAnchor),
            buttonURL.widthAnchor.constraint(equalTo: url.widthAnchor),
            buttonURL.heightAnchor.constraint(equalTo: url.heightAnchor)
        ])
    }
}

