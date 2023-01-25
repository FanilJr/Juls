//
//  ProfileFriendsHeaderView.swift
//  Juls
//
//  Created by Fanil_Jr on 06.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol HeaderFriendsDelegate: AnyObject {
    func backUp()
}

class ProfileFriendsHeaderView: UIView {
    
    var user: User? {
        didSet {
            setupAuth()
            checkUserFollow()
        }
    }
    
    weak var delegate: HeaderFriendsDelegate?

    private var statusText: String = ""
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
        button.setBackgroundImage(UIImage(systemName: "phone.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()

    
    lazy var messageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openMessage), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.2285125894, green: 0.5558477767, blue: 0.9294139743, alpha: 1)
        button.setBackgroundImage(UIImage(systemName: "message.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followFriend), for: .touchUpInside)
        button.tintColor = .white
        button.setBackgroundImage(UIImage(systemName: "heart.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.backward.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backUp), for: .touchUpInside)
        return button
    }()
    
    @objc func backUp() {
        delegate?.backUp()
    }
    
    func snp() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        //MARK: ОСНОВНАЯ ИНФОРМАЦИЯ
        [avatarImageView,stackViewVertical].forEach { containerView.addSubview($0) }
        //MARK: Background buttons
        [backViewOne,backViewSecond,backViewThree].forEach { containerView.addSubview($0) }
        //MARK: BUTTONS
        [backButton,messageButton,phoneButton,followButton].forEach { containerView.addSubview($0) }
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
        
        stackViewVertical.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10).isActive = true
        stackViewVertical.heightAnchor.constraint(equalToConstant: 120).isActive = true
        stackViewVertical.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        stackViewVertical.bottomAnchor.constraint(equalTo: messageButton.topAnchor,constant: -20).isActive = true
        
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backViewOne.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        backViewOne.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backViewOne.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backViewOne.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
        
        backViewSecond.trailingAnchor.constraint(equalTo: phoneButton.leadingAnchor,constant: -50).isActive = true
        backViewSecond.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backViewSecond.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backViewSecond.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
        
        backViewThree.leadingAnchor.constraint(equalTo: phoneButton.trailingAnchor,constant: 50).isActive = true
        backViewThree.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backViewThree.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backViewThree.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true

        phoneButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        phoneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        phoneButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
        
        messageButton.trailingAnchor.constraint(equalTo: phoneButton.leadingAnchor,constant: -50).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        messageButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -30).isActive = true
        
        followButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        followButton.centerYAnchor.constraint(equalTo: backViewThree.centerYAnchor).isActive = true
        followButton.centerXAnchor.constraint(equalTo: backViewThree.centerXAnchor).isActive = true
       
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
        
    }

    private func buttonPressed() {
        print("Сделать редактирование")
    }
    
    @objc private func followFriend() {
        
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        let ref = Database.database().reference().child("following").child(myId)
        if self.followButton.backgroundImage(for: .normal) == UIImage(systemName: "heart.circle") {
            let values = [userId: 1]
            ref.updateChildValues(values) { error, ref in
                if let error {
                    print("error", error)
                    return
                }
                DispatchQueue.main.async {
                    print("succes followed user: ", self.user?.username ?? "")
                    self.followButton.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
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
                    self.followButton.setBackgroundImage(UIImage(systemName: "heart.circle"), for: .normal)
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
                self.followButton.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                self.followButton.tintColor = .red
            } else {
                self.followButton.setBackgroundImage(UIImage(systemName: "heart.circle"), for: .normal)
                self.followButton.tintColor = .white
            }
        }
    }
    
    private func addMenuItems() -> UIMenu {
        let changeAvatar = UIAction(title: "Изменить аватар",image: UIImage(systemName: "person.fill.viewfinder")) { _ in
            
        }
        
        let changeStatus = UIAction(title: "Изменить статус", image: UIImage(systemName: "heart.text.square.fill")) { _ in
            
        }
        
        let quit = UIAction(title: "Выйти из аккаунта", image: UIImage(systemName: "hands.sparkles.fill"), attributes: .destructive) { _ in
            
        }
            
        let menu = UIMenu(title: "Выберите действие", children: [changeAvatar, changeStatus, quit])
        return menu
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        statusTextField.delegate = self
        snp()
        tapScreen()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileFriendsHeaderView {
    
    func tapScreen() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
    }
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

extension ProfileFriendsHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !statusText.isEmpty else {
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

//MARK: Получаем данные HEADER конкретного пользователя (с обновлением в реальном времени)
extension ProfileFriendsHeaderView {
    
    func setupAuth() {
        guard let uid = user?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            self.user = User(uid: uid, dictionary: dictionary)
            
            DispatchQueue.main.async {
                guard let imageUrl = self.user?.picture else { return }
                self.avatarImageView.loadImage(urlString: imageUrl)
                self.nickNameLabel.text = self.user?.username
                self.statusLabel.text = self.user?.status
            }
        }) { err in
            print("Failet to setup user", err)
        }
    }
}
