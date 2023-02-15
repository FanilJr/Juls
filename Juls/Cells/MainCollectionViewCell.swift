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
}

class MainCollectionViewCell: UICollectionViewCell {
    
    var usersFollowMe = [String]()
    var countUser = [String]()
    var countFollowWithUser = [String]()
    
    weak var delegate: MainCollectionDelegate?
    
    private lazy var info: UILabel = {
        let name = UILabel()
        name.text = "О себе:"
        name.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var first: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Имя:"
        return nothing
    }()
    
    lazy var two: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Возраст:"
        return nothing
    }()
    
    lazy var three: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Семейное положение:"
        return nothing
    }()
    
    lazy var four: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Рост:"
        return nothing
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        name.text = "-"
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
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.text = "-"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLife: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heightUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ageUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iFollow: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Подписки"
        return nothing
    }()
    
    lazy var followMe: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Подписчики"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        [iFollowButton, followMeButton, iFollow, followMe, info, first,two,three,four, name, ageUser, statusLife, heightUser, editButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            
            iFollowButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            iFollowButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -60),
            iFollowButton.heightAnchor.constraint(equalToConstant: 30),
            iFollowButton.widthAnchor.constraint(equalToConstant: 30),
            
            followMeButton.centerYAnchor.constraint(equalTo: iFollowButton.centerYAnchor),
            followMeButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: 60),
            followMeButton.heightAnchor.constraint(equalToConstant: 30),
            followMeButton.widthAnchor.constraint(equalToConstant: 30),
            
            iFollow.topAnchor.constraint(equalTo: iFollowButton.bottomAnchor),
            iFollow.centerXAnchor.constraint(equalTo: iFollowButton.centerXAnchor),
            
            followMe.centerYAnchor.constraint(equalTo: iFollow.centerYAnchor),
            followMe.centerXAnchor.constraint(equalTo: followMeButton.centerXAnchor),
            
            
            info.topAnchor.constraint(equalTo: iFollow.bottomAnchor,constant: 10),
            info.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            editButton.centerYAnchor.constraint(equalTo: info.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            editButton.heightAnchor.constraint(equalToConstant: 25),
            editButton.widthAnchor.constraint(equalToConstant: 25),
            
            first.topAnchor.constraint(equalTo: info.bottomAnchor,constant: 10),
            first.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            two.topAnchor.constraint(equalTo: first.bottomAnchor,constant: 10),
            two.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            three.topAnchor.constraint(equalTo: two.bottomAnchor,constant: 10),
            three.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            
            four.topAnchor.constraint(equalTo: three.bottomAnchor,constant: 10),
            four.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            four.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            
            name.topAnchor.constraint(equalTo: info.bottomAnchor,constant: 10),
            name.centerYAnchor.constraint(equalTo: first.centerYAnchor),
            name.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            ageUser.topAnchor.constraint(equalTo: name.bottomAnchor,constant: 10),
            ageUser.centerYAnchor.constraint(equalTo: two.centerYAnchor),
            ageUser.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            statusLife.topAnchor.constraint(equalTo: ageUser.bottomAnchor,constant: 10),
            statusLife.centerYAnchor.constraint(equalTo: three.centerYAnchor),
            statusLife.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            heightUser.topAnchor.constraint(equalTo: statusLife.bottomAnchor,constant: 10),
            heightUser.centerYAnchor.constraint(equalTo: four.centerYAnchor),
            heightUser.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10)
        ])
    }
    
    func configureMain(user: User?) {
        guard let currentLoggetUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggetUserId != userId {
            self.editButton.alpha = 0.0
            self.editButton.isEnabled = true
        } else {
            self.editButton.setBackgroundImage(UIImage(systemName: "pencil.circle"), for: .normal)
        }
        
        name.text = user?.name
        ageUser.text = user?.age
        statusLife.text = user?.lifeStatus
        heightUser.text = user?.height
    }
}
