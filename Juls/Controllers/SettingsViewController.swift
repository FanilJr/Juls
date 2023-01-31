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
    private let imagePicker = UIImagePickerController()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
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
    
    private let avatarChangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeAvatar), for: .touchUpInside)
        button.setTitle("Редактировать", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        navigationItem.titleView = juls
        layout()
        imagePicker.delegate = self
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
    
    @objc func changeAvatar() {
        present(imagePicker, animated: true)
    }
    
    func layout() {
        [background,avatarImageView,avatarChangeButton,spinnerView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: background.safeAreaLayoutGuide.topAnchor,constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            avatarChangeButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor,constant: 20),
            avatarChangeButton.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            avatarChangeButton.heightAnchor.constraint(equalToConstant: 40),
            avatarChangeButton.widthAnchor.constraint(equalToConstant: 200),
            
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
//            guard let avatarImageUrl = user.picture else { return }
            self.avatarImageView.loadImage(urlString: user.picture)
        }
    }
    
    func saveChanges() {
        let imageName = NSUUID().uuidString
        let storedImage = Storage.storage().reference().child("profile_image").child(imageName)

        if let uploadData = avatarImageView.image?.jpegData(compressionQuality: 0.3) {
            storedImage.putData(uploadData, metadata: nil) { metadata, error in
                if let error {
                    print("error upload", error)
                    return
                }
                storedImage.downloadURL(completion: { url, error in
                    if let error {
                        print(error)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["picture" : urlText]) { error, ref in
                            if let error {
                                print(error)
                                return
                            }
                            print("succes download Photo in Firebase Library")
                            self.waitingSpinnerEnable(false)
                            self.view.addSubview(self.saveView)
                            NSLayoutConstraint.activate([
                                self.saveView.centerYAnchor.constraint(equalTo: self.avatarImageView.centerYAnchor),
                                self.saveView.centerXAnchor.constraint(equalTo: self.avatarImageView.centerXAnchor),
                                self.saveView.heightAnchor.constraint(equalToConstant: 80),
                                self.saveView.widthAnchor.constraint(equalToConstant: 80)
                            ])
                            UIView.animate(withDuration: 0.7) {
                                self.saveView.alpha = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.1) {
                                UIView.animate(withDuration: 1) {
                                    self.saveView.alpha = 0
                                }
                            }
                        }
                    }
                })
            }
        }
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.avatarImageView.image = pickedImage
        self.waitingSpinnerEnable(true)
        self.saveChanges()
        dismiss(animated: true)
    }
}
        
