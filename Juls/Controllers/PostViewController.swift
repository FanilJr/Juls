//
//  PostViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 18.01.2023.
//

import Foundation
import UIKit

protocol PostDelegate: AnyObject {
    func presentAlertImagePicker2()
    func pushPost2()
    func closedPost2()
}

class PostViewController: UIViewController {
    
    weak var delegatePost: PostDelegate?
    
    private let spinnerViewForPost: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    let background: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 14
        background.backgroundColor = .systemGray6
        background.clipsToBounds = true
        background.layer.borderColor = UIColor.lightGray.cgColor
        background.layer.borderWidth = 0.5
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    lazy var customTextfield: CustomTextField = {
        let textField = CustomTextField(placeholder: "Подумайте о хорошем.. ", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.returnKeyType = .done
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 14
        return textField
    }()
    
    let customImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var customAddPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "camera.badge.ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(apendPhotoInPost), for: .touchUpInside)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var sendPostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushPost), for: .touchUpInside)
        button.setTitle("Отправить", for: .normal)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.setTitleColor(.createColor(light: .black, dark: .white), for: .normal)
        button.backgroundColor = .systemCyan
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("отмена", for: .normal)
        button.addTarget(self, action: #selector(closedPost), for: .touchUpInside)
        button.setTitleColor(.createColor(light: .red, dark: .red), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        layout()
    }
    
    func waitingSpinnerPostEnable(_ active: Bool) {
        if active {
            spinnerViewForPost.startAnimating()
        } else {
            spinnerViewForPost.stopAnimating()
        }
    }
    
    @objc func apendPhotoInPost() {
        delegatePost?.presentAlertImagePicker2()
    }
    
    @objc func pushPost() {
        delegatePost?.pushPost2()
        sendPostButton.setTitle("", for: .normal)
        sendPostButton.setImage(UIImage(), for: .normal)
        waitingSpinnerPostEnable(true)
    }
    
    @objc func closedPost() {
        delegatePost?.closedPost2()
    }
    
    func layout() {
        [background,customTextfield,customImage,customAddPhotoButton,sendPostButton,spinnerViewForPost,cancelButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            customTextfield.topAnchor.constraint(equalTo: background.topAnchor,constant: 40),
            customTextfield.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 20),
            customTextfield.trailingAnchor.constraint(equalTo: background.trailingAnchor,constant: -20),
            customTextfield.heightAnchor.constraint(equalToConstant: 40),
            
            customImage.topAnchor.constraint(equalTo: customTextfield.bottomAnchor,constant: 10),
            customImage.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            customImage.heightAnchor.constraint(equalToConstant: 300),
            customImage.widthAnchor.constraint(equalToConstant: 160),
            
            sendPostButton.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            sendPostButton.topAnchor.constraint(equalTo: customImage.bottomAnchor,constant: 10),
            sendPostButton.heightAnchor.constraint(equalToConstant: 40),
            sendPostButton.widthAnchor.constraint(equalToConstant: 150),
            
            spinnerViewForPost.centerXAnchor.constraint(equalTo: sendPostButton.centerXAnchor),
            spinnerViewForPost.centerYAnchor.constraint(equalTo: sendPostButton.centerYAnchor),
  
            customAddPhotoButton.centerYAnchor.constraint(equalTo: sendPostButton.centerYAnchor),
            customAddPhotoButton.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 25),
            
            cancelButton.centerYAnchor.constraint(equalTo: sendPostButton.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: background.trailingAnchor,constant: -25),
        ])
    }
}
