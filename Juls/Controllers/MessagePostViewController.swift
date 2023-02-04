//
//  PostViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 18.01.2023.
//

import Foundation
import UIKit

protocol MessagePostDelegate: AnyObject {
    func presentPostImagePicker()
    func pushPostDelegate()
    func closedPostPostDelegate()
}

class MessagePostViewController: UIViewController {
    
    weak var delegatePost: MessagePostDelegate?
    
    private let spinnerViewForPost: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    let background: UIImageView = {
        let background = UIImageView()
        background.image = UIImage(named: "back")
//        background.clipsToBounds = true
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    lazy var customTextfield: UITextView = {
        let textField = UITextView()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .light)
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.returnKeyType = .done
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 12
        textField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let customImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 14
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
    
    @objc func tapDone() {
        self.view.endEditing(true)
    }
    
    func waitingSpinnerPostEnable(_ active: Bool) {
        if active {
            spinnerViewForPost.startAnimating()
        } else {
            spinnerViewForPost.stopAnimating()
        }
    }
    
    @objc func apendPhotoInPost() {
        delegatePost?.presentPostImagePicker()
    }
    
    @objc func pushPost() {
        delegatePost?.pushPostDelegate()
        sendPostButton.setTitle("", for: .normal)
        sendPostButton.setImage(UIImage(), for: .normal)
        waitingSpinnerPostEnable(true)
    }
    
    @objc func closedPost() {
        delegatePost?.closedPostPostDelegate()
    }
    
    func layout() {
        [background,cancelButton,sendPostButton,customTextfield,customImage,customAddPhotoButton,spinnerViewForPost].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: background.topAnchor,constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 20),
            
            sendPostButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            sendPostButton.trailingAnchor.constraint(equalTo: background.trailingAnchor,constant: -20),
            sendPostButton.heightAnchor.constraint(equalToConstant: 40),
            sendPostButton.widthAnchor.constraint(equalToConstant: 120),
            
            customTextfield.topAnchor.constraint(equalTo: cancelButton.bottomAnchor,constant: 20),
            customTextfield.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 20),
            customTextfield.trailingAnchor.constraint(equalTo: background.trailingAnchor,constant: -20),
            customTextfield.heightAnchor.constraint(equalToConstant: 44),
            
            customImage.topAnchor.constraint(equalTo: customTextfield.bottomAnchor,constant: 20),
            customImage.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            customImage.heightAnchor.constraint(equalToConstant: 280),
            customImage.widthAnchor.constraint(equalToConstant: 150),
            
            spinnerViewForPost.centerXAnchor.constraint(equalTo: sendPostButton.centerXAnchor),
            spinnerViewForPost.centerYAnchor.constraint(equalTo: sendPostButton.centerYAnchor),
  
            customAddPhotoButton.topAnchor.constraint(equalTo: customTextfield.bottomAnchor,constant: 20),
            customAddPhotoButton.leadingAnchor.constraint(equalTo: background.leadingAnchor,constant: 20)
        ])
    }
}

extension MessagePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
