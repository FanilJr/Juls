//
//  StretchyCollectionHeaderView.swift
//  Juls
//
//  Created by Fanil_Jr on 27.01.2023.
//

import UIKit
import Firebase

class StretchyCollectionHeaderView: UICollectionReusableView {
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.picture else { return }
            if imageUrl == "" {
                self.userImage.image = UIImage(named: "noimage")
            } else {
                self.userImage.loadImage(urlString: imageUrl)
            }
            self.statusLabel.text = user?.status
            setupEditFollowButton()
            checkUserFollow()
        }
    }
    
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
        let statusTextField = CustomTextField(placeholder: "статус", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 15, weight: .regular))
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
        } else {
            self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
            self.followButton.alpha = 1
            self.followButton.isEnabled = true
        }
    }
    
    @objc func followFriend() {
        guard let userId = user?.uid else { return }
        if self.followButton.backgroundImage(for: .normal) == UIImage(named: "heart.circle.fill@100xWhite") {
            Database.database().followUser(withUID: userId) { error in
                if let error {
                    print(error)
                    return
                }
                print("succes followed user: ", self.user?.username ?? "")
                self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100x"), for: .normal)
            }
        } else {
            Database.database().unfollowUser(withUID: userId) { error in
                if let error {
                    print(error)
                    return
                }
                print("succeful unfollow user: ", self.user?.username ?? "")
                self.followButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
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
        [statusLabel].forEach { stackViewVertical.addArrangedSubview($0) }
        [userImage,stackViewVertical,followButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: topAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            userImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            stackViewVertical.heightAnchor.constraint(equalToConstant: 120),
            stackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewVertical.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -40),
            
            followButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            followButton.heightAnchor.constraint(equalToConstant: 35),
            followButton.widthAnchor.constraint(equalToConstant: 35),
        ])
    }
}
