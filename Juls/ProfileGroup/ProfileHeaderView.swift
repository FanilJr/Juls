//
//  ProfileHeaderView.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import AVFoundation
import UIKit
import Firebase

protocol HeaderDelegate: AnyObject {
    func presentMenuAvatar()
    func presentSettings()
    func postCountsPresent()
    func imagePresentPicker()
    func changeStatus()
    func quitAccaunt()
    func addPost()
    func addPhoto()
}

final class ProfileHeaderView: UIView {

    var user: User? {
        didSet {
            guard let imageUrl = user?.picture else { return }
            self.avatarImageView.loadImage(urlString: imageUrl)
            self.nickNameLabel.text = user?.username
            self.statusLabel.text = user?.status
        }
    }

    weak var delegate: HeaderDelegate?
    private var statusText: String = ""
    let systemSoundID: SystemSoundID = 1016
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    lazy var avatarImageView: CustomImageView = {
        let avatarImageView = CustomImageView()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(expandAvatar))
        avatarImageView.addGestureRecognizer(tapGesture)
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .black
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
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
        
    private let stackViewVertical: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let backViewOne: UIView = {
        let back = UIView()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.layer.cornerRadius = 50/2
        back.clipsToBounds = true
        back.backgroundColor = .black
        back.alpha = 0.5
        return back
    }()
    
    private let backViewSecond: UIView = {
        let back = UIView()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.layer.cornerRadius = 50/2
        back.clipsToBounds = true
        back.backgroundColor = .black
        back.alpha = 0.5
        return back
    }()
    
    private let backViewThree: UIView = {
        let back = UIView()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.layer.cornerRadius = 50/2
        back.clipsToBounds = true
        back.backgroundColor = .black
        back.alpha = 0.5
        return back
    }()
    
    private let stackViewHorizontalButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 50
        stackView.layer.cornerRadius = 50/2
        stackView.clipsToBounds = true
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(callNumber), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//        button.setBackgroundImage(UIImage(systemName: "phone.circle"), for: .normal)
        button.setBackgroundImage(UIImage(named: "phone.circle.fill@100x"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()

    
    lazy var messageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openMessage), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.2285125894, green: 0.5558477767, blue: 0.9294139743, alpha: 1)
//        button.setBackgroundImage(UIImage(systemName: "message.circle"), for: .normal)
        button.setBackgroundImage(UIImage(named: "message.circle.fill@100x"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    lazy var albumButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(postsCountPressed), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
//        button.setBackgroundImage(UIImage(systemName: "photo.circle"), for: .normal)
        button.setBackgroundImage(UIImage(named: "photo.circle.fill@100x"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
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
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor.createColor(light: .white, dark: .white)
        button.backgroundColor = .clear
        button.menu = addMenuPlusButton()
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
//    func fetchUser() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        Database.fetchUserWithUID(uid: uid) { user in
//            self.user = user
//            print("Перезагрузка в HEADERVIEW fetchUser")
//        }
//    }
    
    func snp() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        //MARK: ОСНОВНАЯ ИНФОРМАЦИЯ
        [avatarImageView,addButton,editButton,stackViewVertical].forEach { containerView.addSubview($0) }
        //MARK: Background buttons
//        [backViewOne,backViewSecond,backViewThree].forEach { containerView.addSubview($0) }
        //MARK: BUTTONS
        [messageButton,phoneButton,albumButton].forEach { containerView.addSubview($0) }
        //MARK: STACKVERTICAL
        [nickNameLabel, statusLabel].forEach { stackViewVertical.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
        //MARK: оступ аватара здесь!        containerView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -15).isActive = true
        containerView.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 620).isActive = true
        
        editButton.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 20).isActive = true
        editButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addButton.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 20).isActive = true
        addButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor,constant: -20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackViewVertical.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10).isActive = true
        stackViewVertical.heightAnchor.constraint(equalToConstant: 120).isActive = true
        stackViewVertical.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        stackViewVertical.bottomAnchor.constraint(equalTo: messageButton.topAnchor,constant: -20).isActive = true
//
//        backViewOne.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        backViewOne.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        backViewOne.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        backViewOne.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
//
//        backViewSecond.trailingAnchor.constraint(equalTo: phoneButton.leadingAnchor,constant: -50).isActive = true
//        backViewSecond.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        backViewSecond.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        backViewSecond.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
//
//        backViewThree.leadingAnchor.constraint(equalTo: phoneButton.trailingAnchor,constant: 50).isActive = true
//        backViewThree.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        backViewThree.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        backViewThree.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true

        phoneButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        phoneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        phoneButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
        
        messageButton.trailingAnchor.constraint(equalTo: phoneButton.leadingAnchor,constant: -50).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        messageButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
        
        albumButton.leadingAnchor.constraint(equalTo: phoneButton.trailingAnchor,constant: 50).isActive = true
        albumButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        albumButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        albumButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
       
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        imageViewBottom = avatarImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = avatarImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
    @objc func openMessage() {
        
    }
    
    @objc func callNumber() {
        
    }
    
    @objc func expandAvatar() {
        self.delegate?.presentMenuAvatar()
    }

    private func buttonPressed() {
        print("Сделать редактирование")
    }
    
    @objc private func postsCountPressed() {
        self.delegate?.postCountsPresent()
    }
    
    private func addMenuItems() -> UIMenu {
        let changeAvatar = UIAction(title: "Изменить аватар",image: UIImage(systemName: "person.fill.viewfinder")) { _ in
            self.delegate?.imagePresentPicker()
        }
        
        let changeStatus = UIAction(title: "Изменить статус", image: UIImage(systemName: "heart.text.square.fill")) { _ in
            self.delegate?.changeStatus()
        }
        
        let quit = UIAction(title: "Выйти из аккаунта", image: UIImage(systemName: "hands.sparkles.fill"), attributes: .destructive) { _ in
            self.delegate?.quitAccaunt()
        }
            
        let menu = UIMenu(title: "Выберите действие", children: [changeAvatar, changeStatus, quit])
        return menu
    }
    
    private func addMenuPlusButton() -> UIMenu {
        let addPost = UIAction(title: "Создать пост",image: UIImage(systemName: "square.and.pencil")) { _ in
            self.delegate?.addPost()
        }
        
        let addPhoto = UIAction(title: "Добавить фото", image: UIImage(systemName: "plus.viewfinder")) { _ in
            self.delegate?.addPhoto()
        }
            
        let menu = UIMenu(title: "Выберите действие", children: [addPost, addPhoto])
        return menu
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        fetchUser()
        statusTextField.delegate = self
        snp()
        tapScreen()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileHeaderView {
    
    func tapScreen() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
    }
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

extension ProfileHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !statusText.isEmpty else {
            AudioServicesPlaySystemSound(self.systemSoundID)
            let bonds = self.statusLabel.bounds
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveLinear) {
                self.statusLabel.bounds = CGRect(x: bonds.origin.x, y: bonds.origin.y, width: bonds.width + 50, height: bonds.height)
            }
            self.statusLabel.text = self.statusTextField.text
            self.statusTextField.text = ""
            
            print("Статус установлен")
            endEditing(true)
            return true
        }
        return true
    }
}
