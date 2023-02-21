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
    
    var usersFollowMe = [String]()
    var countUser = [String]()
    var countFollowWithUser = [String]()
    
    weak var delegate: MainCollectionDelegate?
    
    lazy var blureForCell: UIVisualEffectView = {
        let bluereEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blure = UIVisualEffectView()
        blure.effect = bluereEffect
        blure.translatesAutoresizingMaskIntoConstraints = false
        blure.layer.cornerRadius = 14
        blure.clipsToBounds = true
        return blure
    }()
    
    private lazy var info: UILabel = {
        let name = UILabel()
        name.text = "О себе:"
        name.shadowColor = .white
        name.font = .systemFont(ofSize: 20, weight: .heavy)
        name.shadowOffset = CGSize(width: 0.5, height: 0.5)
        name.clipsToBounds = true
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var first: UILabel = {
        let nothing = UILabel()
        nothing.shadowColor = .white
        nothing.font = .systemFont(ofSize: 15.0, weight: .semibold)
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Имя:"
        return nothing
    }()
    
    lazy var two: UILabel = {
        let nothing = UILabel()
        nothing.shadowColor = .white
        nothing.font = .systemFont(ofSize: 15.0, weight: .semibold)
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Возраст:"
        return nothing
    }()
    
    lazy var three: UILabel = {
        let nothing = UILabel()
        nothing.shadowColor = .white
        nothing.font = .systemFont(ofSize: 15.0, weight: .semibold)
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Семейное положение:"
        return nothing
    }()
    
    lazy var four: UILabel = {
        let nothing = UILabel()
        nothing.shadowColor = .white
        nothing.font = .systemFont(ofSize: 15.0, weight: .semibold)
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Рост:"
        return nothing
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.text = "-"
        name.textColor = UIColor.createColor(light: .white, dark: .white)
        name.shadowColor = .black
        name.font = .systemFont(ofSize: 15, weight: .bold)
        name.shadowOffset = CGSize(width: 1, height: 1)
        name.clipsToBounds = true
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var friends: UILabel = {
        let status = UILabel()
        status.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        status.text = "-"
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = UIColor.createColor(light: .white, dark: .white)
        label.shadowColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLife: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.createColor(light: .white, dark: .white)
        label.shadowColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.clipsToBounds = true
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heightUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .white, dark: .white)
        label.shadowColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.clipsToBounds = true
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ageUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .white, dark: .white)
        label.shadowColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.clipsToBounds = true
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iFollow: UILabel = {
        let nothing = UILabel()
//        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        nothing.shadowColor = .white
        nothing.font = .systemFont(ofSize: 15, weight: .bold)
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "подписки"
        return nothing
    }()
    
    lazy var followMe: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        nothing.shadowColor = .white
        nothing.shadowOffset = CGSize(width: 0.5, height: 0.5)
        nothing.clipsToBounds = true
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "подписчики"
        return nothing
    }()
    
    lazy var postsCount: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(getUsersIFollow), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var followMeButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(getUsersFollowMe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(tapPosts), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
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
        [blureForCell,postsButton,iFollowButton,followMeButton,postsCount,iFollow,followMe,info,first,two,three,four, name,ageUser,statusLife,heightUser,editButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            
            blureForCell.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            blureForCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            blureForCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            blureForCell.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
            
            postsButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            postsButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 80),
            postsButton.heightAnchor.constraint(equalToConstant: 30),
            postsButton.widthAnchor.constraint(equalToConstant: 30),
            
            iFollowButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            iFollowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            iFollowButton.heightAnchor.constraint(equalToConstant: 30),
            iFollowButton.widthAnchor.constraint(equalToConstant: 30),
            
            followMeButton.centerYAnchor.constraint(equalTo: iFollowButton.centerYAnchor),
            followMeButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -80),
            followMeButton.heightAnchor.constraint(equalToConstant: 30),
            followMeButton.widthAnchor.constraint(equalToConstant: 30),
            
            postsCount.topAnchor.constraint(equalTo: postsButton.bottomAnchor),
            postsCount.centerXAnchor.constraint(equalTo: postsButton.centerXAnchor),
            
            iFollow.topAnchor.constraint(equalTo: iFollowButton.bottomAnchor),
            iFollow.centerXAnchor.constraint(equalTo: iFollowButton.centerXAnchor),
            
            followMe.centerYAnchor.constraint(equalTo: iFollow.centerYAnchor),
            followMe.centerXAnchor.constraint(equalTo: followMeButton.centerXAnchor),
            
            info.topAnchor.constraint(equalTo: iFollow.bottomAnchor,constant: 10),
            info.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            editButton.centerYAnchor.constraint(equalTo: info.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            editButton.heightAnchor.constraint(equalToConstant: 20),
            editButton.widthAnchor.constraint(equalToConstant: 20),
            
            first.topAnchor.constraint(equalTo: info.bottomAnchor,constant: 10),
            first.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            two.topAnchor.constraint(equalTo: first.bottomAnchor,constant: 10),
            two.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            three.topAnchor.constraint(equalTo: two.bottomAnchor,constant: 10),
            three.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            four.topAnchor.constraint(equalTo: three.bottomAnchor,constant: 10),
            four.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            four.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -15),
            
            name.topAnchor.constraint(equalTo: info.bottomAnchor,constant: 10),
            name.centerYAnchor.constraint(equalTo: first.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            ageUser.topAnchor.constraint(equalTo: name.bottomAnchor,constant: 10),
            ageUser.centerYAnchor.constraint(equalTo: two.centerYAnchor),
            ageUser.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            statusLife.topAnchor.constraint(equalTo: ageUser.bottomAnchor,constant: 10),
            statusLife.centerYAnchor.constraint(equalTo: three.centerYAnchor),
            statusLife.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            heightUser.topAnchor.constraint(equalTo: statusLife.bottomAnchor,constant: 10),
            heightUser.centerYAnchor.constraint(equalTo: four.centerYAnchor),
            heightUser.leadingAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func configureMain(user: User?) {
        guard let currentLoggetUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggetUserId != userId {
            self.editButton.alpha = 0.0
            self.editButton.isEnabled = true
        } else {
            self.editButton.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        }
        name.text = user?.name
        ageUser.text = user?.age
        statusLife.text = user?.lifeStatus
        heightUser.text = user?.height
    }
}
