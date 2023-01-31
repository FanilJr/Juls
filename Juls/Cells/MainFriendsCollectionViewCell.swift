//
//  MainFriendsCollectionViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 28.01.2023.
//

import Foundation
import UIKit
import Firebase

class MainFriendsCollectionViewCell: UICollectionViewCell {
    
    var usersFollowMe = [String]()
    var countUser = [String]()
    
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
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var friends: UILabel = {
        let status = UILabel()
        status.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLife: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heightUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ageUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
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
    
    private lazy var iFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var followMeButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    func setupCell() {
        [iFollowButton, followMeButton, iFollow, followMe, info, first,two,three,four, name, ageUser, statusLife, heightUser].forEach { addSubview($0) }
        
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
        name.text = user?.name
        ageUser.text = user?.age
        statusLife.text = user?.lifeStatus
        heightUser.text = user?.height
    }
}

extension MainFriendsCollectionViewCell {
    
    func checkIFollowing(user: User?) {
        guard let userId = user?.uid else { return }
        
        let ref = Database.database().reference().child("following").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let iFollowUsers = snapshot.value as? [String: Any] else { return }
//            print(iFollowUsers.count, "кол-во моих подписок")
            self.iFollowButton.setTitle("\(iFollowUsers.count)", for: .normal)
        })
    }
    
    func checkFollowMe(user: User?) {
        guard let userId = user?.uid else { return }
        let ref = Database.database().reference().child("following")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let iFollowUsers = snapshot.value as? [String: Any] else { return }
            iFollowUsers.forEach { key, value in
//                print(key)
                if key != userId {
                    self.usersFollowMe.append(key)
//                    print(self.usersFollowMe.count, self.usersFollowMe, "количество людей, кто вобще подписывался на кого либо, но без меня")
                }
            }
//            self.loadFollowUsers(user: user)
        })
    }
    
    func loadFollowUsers(user: User?) {
        for i in usersFollowMe {
            let uidUsers = i
            let ref = Database.database().reference().child("following").child(uidUsers)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard let followMeUsers = snapshot.value as? [String: Any] else { return }
                followMeUsers.forEach { key, value in
                    if key == user?.uid {
                        self.countUser.append(uidUsers)
                        
                        let setCountUser = Set(Array(self.countUser))
//                        print(setCountUser, "кто и сколько на меня подписок", setCountUser.count)
                        self.followMeButton.setTitle("\(setCountUser.count)", for: .normal)
                    }
                }
            })
        }
    }
}
