//
//  SettingsViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController {
    
    var user: User?
    var juls = JulsView()
    var saveView = SaveView()
    var header = ProfileHeaderView()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "sunset")
        back.clipsToBounds = true
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    lazy var avatarImageView: CustomImageView = {
        let avatarImageView = CustomImageView()
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .black
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 150/2
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        navigationItem.titleView = juls
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
    
    func layout() {
        [background,avatarImageView,spinnerView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: background.safeAreaLayoutGuide.topAnchor,constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            spinnerView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
}

extension SettingsViewController {
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            guard let avatarImageUrl = user.picture else { return }
            self.avatarImageView.loadImage(urlString: avatarImageUrl)
        }
    }
}
