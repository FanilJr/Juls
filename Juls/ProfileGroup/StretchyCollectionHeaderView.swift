//
//  StretchyCollectionHeaderView.swift
//  Juls
//
//  Created by Fanil_Jr on 27.01.2023.
//

import UIKit
import Firebase

protocol StretchyDelegate: AnyObject {
    func addPostInCollection()
    func presentImagePickerForUser()
    func addStatus()
    func logOut()
    func showAlbum()
    func setupSettings()
    func backUp()
    func goMessage()
}

class StretchyCollectionHeaderView: UICollectionReusableView {
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.picture else { return }
            if imageUrl == "" {
                self.userImage.image = UIImage(named: "noimage")
            } else {
                self.userImage.loadImage(urlString: imageUrl)
            }
            self.nickNameLabel.text = user?.username
            self.statusLabel.text = user?.status
            
//            self.addButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
//            self.editButton.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
            setupEditFollowButton()
            checkUserFollow()
        }
    }
    
    weak var delegate: StretchyDelegate?
    
    var userImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.backgroundColor = .black
        image.layer.cornerRadius = 14
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let stackViewVertical: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var nickNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(light: .white, dark: .white)
        fullNameLabel.numberOfLines = 0
        fullNameLabel.font = .systemFont(ofSize: 55, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = UIColor.createColor(light: .white, dark: .white)
        statusLabel.shadowColor = .red
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 17, weight: .thin)
        statusLabel.shadowOffset = CGSize(width: 1, height: 1)
        statusLabel.layer.shadowOpacity = 1
        statusLabel.layer.shadowRadius = 30
        statusLabel.clipsToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
    }()
        
    private let statusTextField: CustomTextField = {
        let statusTextField = CustomTextField(placeholder: "header.status".localized, textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 15, weight: .regular))
        statusTextField.tintColor = UIColor(named: "#4885CC")
        statusTextField.layer.cornerRadius = 15
        statusTextField.returnKeyType = .done
        return statusTextField
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followFriend), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    lazy var albumButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(showAlbumController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.createColor(light: .white, dark: .white)
        button.backgroundColor = .clear
        button.menu = addMenuItems()
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.createColor(light: .white, dark: .white)
        button.backgroundColor = .clear
        button.menu = addMenuPlusButton()
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.createColor(light: .white, dark: .white)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    @objc func goMessage() {
        delegate?.goMessage()
    }
    
    @objc func backUp() {
        delegate?.backUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggetUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggetUserId == userId {
            self.followButton.alpha = 0.0
            self.followButton.isEnabled = false
            self.messageButton.setBackgroundImage(UIImage(named: "bubble.left.and.bubble.right.fill@100x"), for: .normal)
            self.addButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
            self.editButton.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        } else {
            self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
            self.addButton.alpha = 0.0
            self.addButton.isEnabled = false
            self.editButton.alpha = 0.0
            self.editButton.isEnabled = false
            self.followButton.alpha = 1
            self.followButton.isEnabled = true
        }
    }
    
    @objc func followFriend() {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        let ref = Database.database().reference().child("following").child(myId)
        if self.followButton.backgroundImage(for: .normal) == UIImage(named: "heart.circle.fill@100xWhite") {
            let values = [userId: 1]
            ref.updateChildValues(values) { error, ref in
                if let error {
                    print("error", error)
                    return
                }
                DispatchQueue.main.async {
                    print("succes followed user: ", self.user?.username ?? "")
                    self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100x"), for: .normal)
                    self.followButton.tintColor = .red
                }
            }
        } else {
            Database.database().reference().child("following").child(myId).child(userId).removeValue { error, ref in
                if let error {
                    print("error", error)
                    return
                }
                DispatchQueue.main.async {
                    print("succeful unfollow user: ", self.user?.username ?? "")
                    self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
                    self.followButton.tintColor = .white
                }
            }
        }
    }
    
    func checkUserFollow() {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        Database.database().reference().child("following").child(myId).child(userId).observe(.value) { snapshot in
                
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100x"), for: .normal)
                self.followButton.tintColor = .red
            } else {
                self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
                self.followButton.tintColor = .white
            }
        }
    }
    
    func layout() {
        [nickNameLabel, statusLabel].forEach { stackViewVertical.addArrangedSubview($0) }
        [userImage,stackViewVertical,messageButton,followButton,editButton,addButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: topAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            userImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageButton.topAnchor.constraint(equalTo: topAnchor,constant: 80),
            messageButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            messageButton.heightAnchor.constraint(equalToConstant: 30),
            messageButton.widthAnchor.constraint(equalToConstant: 33),
            
            editButton.topAnchor.constraint(equalTo: topAnchor,constant: 80),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            
            addButton.topAnchor.constraint(equalTo: topAnchor,constant: 80),
            addButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor,constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            
            stackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            stackViewVertical.heightAnchor.constraint(equalToConstant: 120),
            stackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewVertical.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -100),
            
            followButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            followButton.heightAnchor.constraint(equalToConstant: 70),
            followButton.widthAnchor.constraint(equalToConstant: 70),
            followButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -30),
        ])
    }
    
    @objc func showAlbumController() {
        delegate?.showAlbum()
    }
    
    private func addMenuPlusButton() -> UIMenu {
        let addPost = UIAction(title: "Создать пост",image: UIImage(systemName: "square.and.pencil")) { _ in
            self.delegate?.addPostInCollection()
        }
        let menu = UIMenu(title: "Выберите действие", children: [addPost])
        return menu
    }
    
    private func addMenuItems() -> UIMenu {
        let changeAvatar = UIAction(title: "Изменить аватар",image: UIImage(systemName: "person.fill.viewfinder")) { _ in
            self.delegate?.presentImagePickerForUser()
        }
        
        let changeStatus = UIAction(title: "Изменить статус", image: UIImage(systemName: "heart.text.square.fill")) { _ in
            self.delegate?.addStatus()
        }
        
        let _ = UIAction(title: "Настройки", image: UIImage(systemName: "gear")) { _ in
            self.delegate?.setupSettings()
        }
        
        let quit = UIAction(title: "Выйти из аккаунта", image: UIImage(systemName: "hands.sparkles.fill"), attributes: .destructive) { _ in
            self.delegate?.logOut()
        }
            
        let menu = UIMenu(title: "Выберите действие", children: [changeAvatar, changeStatus, quit])
        return menu
    }
}
