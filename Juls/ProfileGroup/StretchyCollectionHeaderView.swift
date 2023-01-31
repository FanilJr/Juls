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
}

class StretchyCollectionHeaderView: UICollectionReusableView {
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.picture else { return }
            self.userImage.loadImage(urlString: imageUrl)
            self.nickNameLabel.text = user?.username
            self.statusLabel.text = user?.status
            
            self.addButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
            self.editButton.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
            self.messageButton.setBackgroundImage(UIImage(named: "message.circle.fill@100x"), for: .normal)
            self.phoneButton.setBackgroundImage(UIImage(named: "phone.circle.fill@100x"), for: .normal)
            self.albumButton.setBackgroundImage(UIImage(named: "photo.circle.fill@100x"), for: .normal)
        }
    }
    
    weak var delegate: StretchyDelegate?
    
    var userImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.backgroundColor = .black
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
    
    lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()

    
    lazy var messageButton: UIButton = {
        let button = UIButton()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        [nickNameLabel, statusLabel].forEach { stackViewVertical.addArrangedSubview($0) }
        [userImage,stackViewVertical,editButton,addButton,messageButton,phoneButton,albumButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: topAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            userImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            editButton.topAnchor.constraint(equalTo: topAnchor,constant: 50),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            
            addButton.topAnchor.constraint(equalTo: topAnchor,constant: 50),
            addButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor,constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            
            stackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            stackViewVertical.heightAnchor.constraint(equalToConstant: 120),
            stackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewVertical.bottomAnchor.constraint(equalTo: messageButton.topAnchor,constant: -20),
            
            phoneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            phoneButton.heightAnchor.constraint(equalToConstant: 50),
            phoneButton.widthAnchor.constraint(equalToConstant: 50),
            phoneButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -30),
            
            messageButton.trailingAnchor.constraint(equalTo: phoneButton.leadingAnchor,constant: -50),
            messageButton.heightAnchor.constraint(equalToConstant: 50),
            messageButton.widthAnchor.constraint(equalToConstant: 50),
            messageButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -30),
            
            albumButton.leadingAnchor.constraint(equalTo: phoneButton.trailingAnchor,constant: 50),
            albumButton.heightAnchor.constraint(equalToConstant: 50),
            albumButton.widthAnchor.constraint(equalToConstant: 50),
            albumButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -30)
        ])
    }
    
    @objc func showAlbumController() {
        delegate?.showAlbum()
    }
    
    private func addMenuPlusButton() -> UIMenu {
        let addPost = UIAction(title: "Создать пост",image: UIImage(systemName: "square.and.pencil")) { _ in
            self.delegate?.addPostInCollection()
        }
        
        let addPhoto = UIAction(title: "Добавить фото", image: UIImage(systemName: "plus.viewfinder")) { _ in
            print("add Photo")
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
        
        let quit = UIAction(title: "Выйти из аккаунта", image: UIImage(systemName: "hands.sparkles.fill"), attributes: .destructive) { _ in
            self.delegate?.logOut()
        }
            
        let menu = UIMenu(title: "Выберите действие", children: [changeAvatar, changeStatus, quit])
        return menu
    }
}
