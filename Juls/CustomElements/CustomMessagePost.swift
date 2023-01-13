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
        background.backgroundColor = .systemGray2
        background.clipsToBounds = true
        background.layer.borderColor = UIColor.white.cgColor
        background.layer.borderWidth = 2
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    let customImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    lazy var customTextfield: CustomTextField = {
        let textField = CustomTextField(placeholder: "Подумайте о хорошем.. ;)", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .twitter
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 25
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
        button.setBackgroundImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.addTarget(self, action: #selector(pushPost), for: .touchUpInside)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("закрыть", for: .normal)
        button.addTarget(self, action: #selector(closedPost), for: .touchUpInside)
        button.tintColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
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
            customTextfield.heightAnchor.constraint(equalToConstant: 150),
            
            customImage.topAnchor.constraint(equalTo: customTextfield.bottomAnchor,constant: 10),
            customImage.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 20),
            customImage.heightAnchor.constraint(equalToConstant: 80),
            customImage.widthAnchor.constraint(equalToConstant: 45),
  
            customAddPhotoButton.bottomAnchor.constraint(equalTo: background.bottomAnchor,constant: -20),
            customAddPhotoButton.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 20),
            
            sendPostButton.bottomAnchor.constraint(equalTo: background.bottomAnchor,constant: -20),
            sendPostButton.trailingAnchor.constraint(equalTo: background.trailingAnchor,constant: -20),
            
            cancelButton.bottomAnchor.constraint(equalTo: background.bottomAnchor,constant: -13),
            cancelButton.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
