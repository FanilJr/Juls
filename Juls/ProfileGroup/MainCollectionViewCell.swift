//
//  MainCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 27.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol MainCollectionDelegate: AnyObject {
    func editInfo()
    func getUsersIFollow()
    func getUsersFollowMe()
    func tapPosts(for cell: MainCollectionViewCell)
}

class MainCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MainCollectionDelegate?
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.clipsToBounds = true
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var info: UILabel = {
        let name = UILabel()
        name.text = "О себе:"
        name.textColor = UIColor.createColor(light: .black, dark: .white)
        name.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        name.font = UIFont(name: "Futura-Bold", size: 20)
        name.shadowOffset = CGSize(width: 1, height: 1)
        name.clipsToBounds = true
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var status: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.createColor(light: .black, dark: .white)
        label.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura-Bold", size: 14)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iFollow: UILabel = {
        let nothing = UILabel()
        nothing.shadowColor = .white
        nothing.font = UIFont(name: "Futura-Bold", size: 15)
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "подписки"
        return nothing
    }()
    
    lazy var followMe: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont(name: "Futura-Bold", size: 15)
        nothing.shadowColor = .white
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "подписчики"
        return nothing
    }()
    
    lazy var postsCount: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont(name: "Futura-Bold", size: 15)
        nothing.shadowColor = .white
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "посты"
        return nothing
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.createColor(light: .black, dark: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.menu = addMenuItems()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var iFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        button.setTitleColor(UIColor.createColor(light: .black, dark: .white), for: .normal)
        button.addTarget(self, action: #selector(getUsersIFollow), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var followMeButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(UIColor.createColor(light: .black, dark: .white), for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        button.addTarget(self, action: #selector(getUsersFollowMe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(UIColor.createColor(light: .black, dark: .white), for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        button.addTarget(self, action: #selector(tapPosts), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        setupCell()
        self.layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapPosts() {
        delegate?.tapPosts(for: self)
    }
    
    @objc func getUsersFollowMe() {
        delegate?.getUsersFollowMe()
    }
    
    @objc func getUsersIFollow() {
        delegate?.getUsersIFollow()
    }
    
    private func addMenuItems() -> UIMenu {
        let changeInfo = UIAction(title: "Редактировать инфо",image: UIImage(systemName: "person.fill.viewfinder")) { _ in
            self.delegate?.editInfo()
        }
        let menu = UIMenu(title: "Выберите действие", children: [changeInfo])
        return menu
    }
    
    func setupCell() {
        [postsButton,iFollowButton,followMeButton,postsCount,iFollow,followMe,info,status].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            postsButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            postsButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 80),
            postsButton.heightAnchor.constraint(equalToConstant: 30),
            postsButton.widthAnchor.constraint(equalToConstant: 30),
            
            postsCount.topAnchor.constraint(equalTo: postsButton.bottomAnchor),
            postsCount.centerXAnchor.constraint(equalTo: postsButton.centerXAnchor),
            
            iFollowButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            iFollowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            iFollowButton.heightAnchor.constraint(equalToConstant: 30),
            iFollowButton.widthAnchor.constraint(equalToConstant: 30),
            
            iFollow.topAnchor.constraint(equalTo: iFollowButton.bottomAnchor),
            iFollow.centerXAnchor.constraint(equalTo: iFollowButton.centerXAnchor),
            
            followMeButton.centerYAnchor.constraint(equalTo: iFollowButton.centerYAnchor),
            followMeButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -80),
            followMeButton.heightAnchor.constraint(equalToConstant: 30),
            followMeButton.widthAnchor.constraint(equalToConstant: 30),
            
            followMe.centerYAnchor.constraint(equalTo: iFollow.centerYAnchor),
            followMe.centerXAnchor.constraint(equalTo: followMeButton.centerXAnchor),
            
            info.topAnchor.constraint(equalTo: iFollow.bottomAnchor,constant: 15),
            info.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            status.topAnchor.constraint(equalTo: info.bottomAnchor,constant: 7),
            status.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            status.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10)
        ])
    }
    
    func configureMain(user: User?) {
        self.status.text = user?.status
    }
}
