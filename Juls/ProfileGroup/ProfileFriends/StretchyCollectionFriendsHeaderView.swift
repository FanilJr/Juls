//
//  StretchyCollectionFriendsHeaderView.swift
//  Juls
//
//  Created by Fanil_Jr on 28.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol StretchyFriendsDelegate: AnyObject {
    func back()
}

class StretchyCollectionFriendsHeaderView: UICollectionReusableView {
    
    var user: User? {
        didSet {
//            setupAuth()
            guard let userImageUrl = user?.picture else { return }
            self.userImage.loadImage(urlString: userImageUrl)
            self.nickNameLabel.text = user?.username
            self.statusLabel.text = user?.status
            
            checkUserFollow()
            
            self.messageButton.setBackgroundImage(UIImage(named: "message.circle.fill@100x"), for: .normal)
            self.phoneButton.setBackgroundImage(UIImage(named: "phone.circle.fill@100x"), for: .normal)
        }
    }
    
    weak var delegate: StretchyFriendsDelegate?
    
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
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followFriend), for: .touchUpInside)
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backUp() {
        delegate?.back()
    }
    
    func layout() {
        [nickNameLabel, statusLabel].forEach { stackViewVertical.addArrangedSubview($0) }
        [userImage,backButton,stackViewVertical,messageButton,phoneButton,followButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: topAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            userImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: topAnchor,constant: 50),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
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
            
            followButton.leadingAnchor.constraint(equalTo: phoneButton.trailingAnchor,constant: 50),
            followButton.heightAnchor.constraint(equalToConstant: 50),
            followButton.widthAnchor.constraint(equalToConstant: 50),
            followButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -30)
        ])
    }
    
    @objc private func followFriend() {
        
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
    
    func setupAuth() {
        guard let uid = user?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            self.user = User(uid: uid, dictionary: dictionary)
            
            DispatchQueue.main.async {
                guard let imageUrl = self.user?.picture else { return }
                self.userImage.loadImage(urlString: imageUrl)
                self.nickNameLabel.text = self.user?.username
                self.statusLabel.text = self.user?.status
            }
        }) { err in
            print("Failet to setup user", err)
        }
    }
}
