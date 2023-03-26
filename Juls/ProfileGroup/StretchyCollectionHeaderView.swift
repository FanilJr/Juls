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
                self.userImage.image = UIImage(named: "noimage")
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
        image.backgroundColor = .black
        image.layer.cornerRadius = 20
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
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(followFriend), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
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
        [userImage,followButton,progressBar,playSongButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: topAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            userImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            followButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            followButton.heightAnchor.constraint(equalToConstant: 35),
            followButton.widthAnchor.constraint(equalToConstant: 35),
            
            progressBar.topAnchor.constraint(equalTo: userImage.topAnchor,constant: 10),
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 70),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -70),
            
            playSongButton.topAnchor.constraint(equalTo: userImage.topAnchor,constant: 10),
            playSongButton.trailingAnchor.constraint(equalTo: userImage.trailingAnchor,constant: -10),
            playSongButton.heightAnchor.constraint(equalToConstant: 35),
            playSongButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
}

