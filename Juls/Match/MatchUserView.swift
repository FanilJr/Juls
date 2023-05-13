//
//  MatchUserView.swift
//  Juls
//
//  Created by Fanil_Jr on 12.04.2023.
//

import Foundation
import UIKit
import Firebase

protocol MatchUserViewProtocol: AnyObject {
    func closed()
    func write()
    func addFriend()
    func tapImage()
}

class MatchUserView: UIView {
    
    weak var delegate: MatchUserViewProtocol?
    
    var user: User? {
        didSet {
            guard let image = user?.picture else { return }
            guard let name = user?.username else { return }
            self.userImage.loadImage(urlString: image)
            self.nameUserLabel.text = name
            self.checkUserFollow()
        }
    }
    
    var raiting: Raiting? {
        didSet {
            guard let raiting = raiting?.rating else { return }
            self.userRaiting.text = "Рейтинг - \(raiting)"
        }
    }
    
    var confettiGifImage: UIImageView = {
        let gif = UIImageView()
        gif.contentMode = .scaleAspectFill
        gif.translatesAutoresizingMaskIntoConstraints = false
        return gif
    }()
    
    var matchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.createColor(light: .systemPurple, dark: .systemPurple)
        label.shadowColor = UIColor.createColor(light: .black, dark: .black)
        label.font = UIFont(name: "Futura-Bold", size: 40)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.text = "It's MATCH!"
        return label
    }()
    
    lazy var userImage: CustomImageView = {
        let image = CustomImageView()
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapImage))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var nameUserLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.createColor(light: .black, dark: .black)
        name.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        name.font = UIFont(name: "Futura-Bold", size: 30)
        name.shadowOffset = CGSize(width: 1, height: 1)
        return name
    }()
    
    var userRaiting: UILabel = {
        let raiting = UILabel()
        raiting.translatesAutoresizingMaskIntoConstraints = false
        raiting.textColor = UIColor.createColor(light: .black, dark: .black)
        raiting.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        raiting.font = UIFont(name: "Futura-Bold", size: 20)
        raiting.shadowOffset = CGSize(width: 1, height: 1)
        raiting.alpha = 0.0
        return raiting
    }()
    
    lazy var writeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("Написать", for: .normal)
        button.addTarget(self, action: #selector(writeUser), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "square.and.pencil")
        config.imagePadding = 5
        button.alpha = 0.0
        button.configuration = config
        return button
    }()
    
    lazy var addFriendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addFriendMatch), for: .touchUpInside)
        button.setTitle("Добавить", for: .normal)
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        config.imagePadding = 5
        button.alpha = 0.0
        button.configuration = config
        return button
    }()
    
    lazy var closedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .red
        button.alpha = 0.0
        button.addTarget(self, action: #selector(tapClosed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.0
        layout()
        addConfetti()
    }
    
    func addConfetti() {
        let confettiGif = UIImage.gifImageWithName("confetti", speed: 3000)
        confettiGifImage.image = confettiGif
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkUserFollow() {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        Database.database().reference().child("following").child(myId).child(userId).observe(.value) { snapshot in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                var config = UIButton.Configuration.filled()
                config.image = UIImage(systemName: "person.crop.circle.fill.badge.checkmark")
                config.imagePadding = 5
                self.addFriendButton.configuration = config
                self.addFriendButton.tintColor = .systemGreen
                self.addFriendButton.setTitle("it's Friend", for: .normal)
            } else {
                var config = UIButton.Configuration.filled()
                config.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
                config.imagePadding = 5
                self.addFriendButton.configuration = config
                self.addFriendButton.tintColor = .systemBlue
                self.addFriendButton.setTitle("Добавить в друзья", for: .normal)
                self.addFriendButton.tintColor = .systemBlue
            }
        }
    }
    
    @objc func tapImage() {
        delegate?.tapImage()
    }
    
    @objc func writeUser() {
        delegate?.write()
    }
    
    @objc func addFriendMatch() {
        delegate?.addFriend()
    }
    
    @objc func tapClosed() {
        delegate?.closed()
    }
    
    func layout() {
        [confettiGifImage,closedButton,matchLabel,userImage,nameUserLabel,userRaiting,writeButton,addFriendButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            confettiGifImage.widthAnchor.constraint(equalTo: widthAnchor),
            confettiGifImage.heightAnchor.constraint(equalTo: heightAnchor),
            confettiGifImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            confettiGifImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            closedButton.topAnchor.constraint(equalTo: topAnchor,constant: 30),
            closedButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -30),
            closedButton.heightAnchor.constraint(equalToConstant: 25),
            closedButton.widthAnchor.constraint(equalToConstant: 25),
            
            matchLabel.topAnchor.constraint(equalTo: closedButton.bottomAnchor,constant: 20),
            matchLabel.trailingAnchor.constraint(equalTo: leadingAnchor),
            
            userImage.topAnchor.constraint(equalTo: matchLabel.bottomAnchor,constant: 20),
            userImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 200),
            userImage.heightAnchor.constraint(equalToConstant: 200),
            
            nameUserLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor,constant: 20),
            nameUserLabel.leadingAnchor.constraint(equalTo: trailingAnchor),
            
            userRaiting.topAnchor.constraint(equalTo: nameUserLabel.bottomAnchor,constant: 10),
            userRaiting.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            writeButton.topAnchor.constraint(equalTo: userRaiting.bottomAnchor,constant: 40),
            writeButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 40),
            writeButton.heightAnchor.constraint(equalToConstant: 40),
            
            addFriendButton.topAnchor.constraint(equalTo: userRaiting.bottomAnchor,constant: 40),
            addFriendButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -40),
            addFriendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
