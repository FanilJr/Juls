//
//  StretchyCollectionHeaderView.swift
//  Juls
//
//  Created by Fanil_Jr on 27.01.2023.
//

import UIKit
import Firebase
import FirebaseStorage

protocol StretchyProtocol: AnyObject {
    func play(url: URL)
    func stop()
}

class StretchyCollectionHeaderView: UICollectionReusableView {
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.picture else { return }
            if imageUrl == "" {
                self.userImage.image = UIImage(named: "Grey_full")
            } else {
                self.userImage.loadImage(urlString: imageUrl)
            }
            setupEditFollowButton()
            checkUserFollow()
            fetchMusic()
        }
    }
    
    weak var delegate: StretchyProtocol?
    
    lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .clear
        slider.minimumTrackTintColor = #colorLiteral(red: 0.9294139743, green: 0.2863991261, blue: 0.3659052849, alpha: 1)
        slider.alpha = 0.0
        slider.isEnabled = false
        slider.maximumTrackTintColor = .gray
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var userImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.backgroundColor = .systemGray
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followFriend), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    lazy var likeForRatingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeAcc), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var likeForRatingLabel: UILabel = {
        let name = UILabel()
        name.textColor = UIColor.createColor(light: .black, dark: .white)
        name.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        name.font = UIFont(name: "Futura-Bold", size: 12)
        name.shadowOffset = CGSize(width: 1, height: 1)
        name.clipsToBounds = true
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var playSongButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(playSong), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.9294139743, green: 0.2863991261, blue: 0.3659052849, alpha: 1)
        button.alpha = 0.0
        button.isEnabled = false
        button.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
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
    
    @objc func playSong() {
        if playSongButton.backgroundImage(for: .normal) == UIImage(systemName: "play.circle") {
            guard let uid = user?.uid else { return }
            guard let song = user?.loveSong else { return }
            let storageRef = Storage.storage().reference().child("songs/\(uid)/\(song)")
            storageRef.downloadURL { (url, error) in
                if let error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                } else if let url {
                    self.delegate?.play(url: url)
                    self.playSongButton.setBackgroundImage(UIImage(systemName: "stop.circle"), for: .normal)
                    self.progressBar.alpha = 1.0
                }
            }
        } else {
            self.progressBar.alpha = 0.0
            self.progressBar.value = 0.0
            self.delegate?.stop()
            self.playSongButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    
    func fetchMusic() {
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaty = snapshot.value as? [String: Any] else { return }
            if (dictionaty["loveSong"] != nil) == true {
                self.playSongButton.alpha = 1.0
                self.playSongButton.isEnabled = true
            } else {
                self.playSongButton.alpha = 0.0
                self.playSongButton.isEnabled = false
            }
        })
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggetUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggetUserId == userId {
            self.followButton.alpha = 0.0
            self.followButton.isEnabled = false
            self.likeForRatingButton.alpha = 0.0
            self.likeForRatingButton.isEnabled = false
            self.likeForRatingLabel.alpha = 0.0
        } else {
            self.followButton.setBackgroundImage(UIImage(named: "person.crop.circle.fill.badge.plus@20x"), for: .normal)
            self.followButton.alpha = 1
            self.followButton.isEnabled = true
            self.likeForRatingButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
            self.likeForRatingButton.alpha = 1
            self.likeForRatingButton.isEnabled = true
        }
    }
    
    @objc func likeAcc() {
        self.likeForRatingButton.alpha = 0
        guard let userId = user?.uid else { return }
        if self.likeForRatingButton.backgroundImage(for: .normal) == UIImage(named: "heart.circle.fill@100xWhite") {
            Database.database().likeUserAcc(withUID: userId) { error in
                if let error {
                    print(error)
                    return
                }
                showOrAlpha(object: self.likeForRatingButton, true, 0.1)
                print("succes like userAcc: ", self.user?.username ?? "")
                self.likeForRatingButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100x"), for: .normal)
            }
        } else {
            Database.database().unLikeUserAcc(withUID: userId) { error in
                if let error {
                    print(error)
                    return
                }
                showOrAlpha(object: self.likeForRatingButton, true, 0.1)
                print("succes unlike userAcc: ", self.user?.username ?? "")
                self.likeForRatingButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
            }
        }
    }
    
    @objc func followFriend() {
        self.followButton.alpha = 0
        guard let userId = user?.uid else { return }
        if self.followButton.backgroundImage(for: .normal) == UIImage(named: "person.crop.circle.fill.badge.plus@20x") {
            Database.database().followUser(withUID: userId) { error in
                if let error {
                    print(error)
                    return
                }
                showOrAlpha(object: self.followButton, true, 0.1)
                print("succes followed user: ", self.user?.username ?? "")
                self.followButton.setBackgroundImage(UIImage(named: "person.crop.circle.fill.badge.checkmark@20x"), for: .normal)
            }
        } else {
            Database.database().unfollowUser(withUID: userId) { error in
                if let error {
                    print(error)
                    return
                }
                showOrAlpha(object: self.followButton, true, 0.1)
                print("succeful unfollow user: ", self.user?.username ?? "")
                self.followButton.setBackgroundImage(UIImage(named: "person.crop.circle.fill.badge.plus@20x"), for: .normal)
            }
        }
    }
    
    func checkUserFollow() {
        
        let message = ["Вам нравится аккаунт?","Вы хотите поднять рейтинг пользователю?","Лайк для него - рейтинг для вас","Возможно, он нуждается в вашей поддержке","Представьте, что вы - хороший человек", "Лайкни - если нравится", "Твой же рейтинг выше, помоги ему"]
        
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        Database.database().reference().child("following").child(myId).child(userId).observe(.value) { snapshot in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                self.followButton.setBackgroundImage(UIImage(named: "person.crop.circle.fill.badge.checkmark@20x"), for: .normal)
            } else {
                self.followButton.setBackgroundImage(UIImage(named: "person.crop.circle.fill.badge.plus@20x"), for: .normal)
            }
        }
        
        Database.database().reference().child("YoulikeAcc").child(myId).child(userId).observe(.value) { snapshot in
            if let isLikeAcc = snapshot.value as? Int, isLikeAcc == 1 {
                self.likeForRatingButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100x"), for: .normal)
                self.likeForRatingLabel.text = ""
            } else {
                self.likeForRatingButton.setBackgroundImage(UIImage(named: "heart.circle.fill@100xWhite"), for: .normal)
                self.likeForRatingLabel.text = message.randomElement()
            }
        }
    }
    
    func layout() {
        [userImage,progressBar,playSongButton,likeForRatingButton,followButton,likeForRatingLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: topAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            userImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            progressBar.topAnchor.constraint(equalTo: userImage.topAnchor,constant: 10),
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 70),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -70),
            
            playSongButton.topAnchor.constraint(equalTo: userImage.topAnchor,constant: 10),
            playSongButton.trailingAnchor.constraint(equalTo: userImage.trailingAnchor,constant: -10),
            playSongButton.heightAnchor.constraint(equalToConstant: 35),
            playSongButton.widthAnchor.constraint(equalToConstant: 35),
            
            likeForRatingButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            likeForRatingButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -7),
            likeForRatingButton.heightAnchor.constraint(equalToConstant: 35),
            likeForRatingButton.widthAnchor.constraint(equalToConstant: 35),
            
            followButton.bottomAnchor.constraint(equalTo: likeForRatingButton.topAnchor,constant: -10),
            followButton.centerXAnchor.constraint(equalTo: likeForRatingButton.centerXAnchor,constant: -3),
            followButton.heightAnchor.constraint(equalToConstant: 34),
            followButton.widthAnchor.constraint(equalToConstant: 41),
            
            likeForRatingLabel.centerYAnchor.constraint(equalTo: likeForRatingButton.centerYAnchor),
            likeForRatingLabel.trailingAnchor.constraint(equalTo: likeForRatingButton.leadingAnchor,constant: -10),
        ])
    }
}

