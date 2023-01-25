//
//  CustomAlert.swift
//  Juls
//
//  Created by Fanil_Jr on 07.01.2023.
//

import Foundation
import UIKit

protocol MessagePostDelegate: AnyObject {
    func presentAlertImagePicker()
    func pushPost()
    func closedPost()
}

class CustomMessagePost: UIView {
    
    weak var delegateAlert: MessagePostDelegate?
    
    private var background: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 14
        background.backgroundColor = .systemGray6
        background.clipsToBounds = true
        background.layer.borderColor = UIColor.lightGray.cgColor
        background.layer.borderWidth = 0.5
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    let customImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    lazy var customTextfield: CustomTextField = {
        let textField = CustomTextField(placeholder: "Подумайте о хорошем.. ;)", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .default
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 14
        return textField
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
    
    private lazy var sendPostButton: UIButton = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.0
        layout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func apendPhotoInPost() {
        delegateAlert?.presentAlertImagePicker()
    }
    
    @objc func pushPost() {
        delegateAlert?.pushPost()
    }
    
    @objc func closedPost() {
        delegateAlert?.closedPost()
    }
    
    func layout() {
        [background,customTextfield,customImage,customAddPhotoButton,sendPostButton,cancelButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            customTextfield.topAnchor.constraint(equalTo: background.topAnchor,constant: 20),
            customTextfield.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 20),
            customTextfield.trailingAnchor.constraint(equalTo: background.trailingAnchor,constant: -20),
            customTextfield.heightAnchor.constraint(equalToConstant: 40),
            
            customImage.topAnchor.constraint(equalTo: customTextfield.bottomAnchor,constant: 10),
            customImage.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            customImage.heightAnchor.constraint(equalToConstant: 150),
            customImage.widthAnchor.constraint(equalToConstant: 80),
            
            sendPostButton.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            sendPostButton.bottomAnchor.constraint(equalTo: background.bottomAnchor,constant: -40),
            sendPostButton.heightAnchor.constraint(equalToConstant: 40),
            sendPostButton.widthAnchor.constraint(equalToConstant: 150),
  
            customAddPhotoButton.centerYAnchor.constraint(equalTo: sendPostButton.centerYAnchor),
            customAddPhotoButton.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 25),
            
            cancelButton.centerYAnchor.constraint(equalTo: sendPostButton.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: background.trailingAnchor,constant: -25),
            
            
        ])
    }
}
