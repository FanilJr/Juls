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
    
    weak var delegate: MessagePostDelegate?
    var user: User? {
        didSet {
            guard let image = user?.picture else { return }
            self.imageUser.loadImage(urlString: image)
        }
    }
    
    var imageGif: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 100/2
        return image
    }()
    
    private let spinnerViewForPost: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = UIColor.createColor(light: .black, dark: .white)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    var imageUser: CustomImageView = {
        var image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 50/2
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var customTextfield: UITextView = {
        let textField = UITextView()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .light)
        textField.backgroundColor = .clear
        textField.returnKeyType = .done
        textField.text = "Что нового?"
        textField.textColor = UIColor.lightGray
        textField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    lazy var customImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 14
        image.clipsToBounds = true
        return image
    }()
    
    lazy var customAddPhotoButton: UIButton = {
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
        button.backgroundColor = #colorLiteral(red: 0.6288032532, green: 0.868211925, blue: 1, alpha: 1)
        button.setTitleColor(.createColor(light: .white, dark: .white), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Oтмена", for: .normal)
        button.addTarget(self, action: #selector(closedPost), for: .touchUpInside)
        button.setTitleColor(.createColor(light: .black, dark: .white), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        tapScreen()
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
        delegate?.presentPostImagePicker()
    }
    
    @objc func pushPost() {
        self.sendPostButton.setTitle("", for: .normal)
        let loadPostGif = UIImage.gifImageWithName("J2", speed: 4000)
        imageGif.image = loadPostGif
        
        UIView.animate(withDuration: 0.3) {
            self.sendPostButton.backgroundColor = .clear
            self.view.backgroundColor = .systemGray5
            self.cancelButton.alpha = 0.2
            self.sendPostButton.alpha = 0.2
            self.customAddPhotoButton.alpha = 0.2
            self.customImage.alpha = 0.2
            self.customTextfield.alpha = 0.2
            self.imageUser.alpha = 0.2
        }
        delegate?.pushPostDelegate()
        waitingSpinnerPostEnable(true)
    }
    
    @objc func closedPost() {
        delegate?.closedPostPostDelegate()
        self.customTextfield.text = "Что нового?"
        self.customTextfield.textColor = UIColor.lightGray
    }
    
    func layout() {
        [cancelButton,sendPostButton,imageUser,customTextfield,customImage,customAddPhotoButton,spinnerViewForPost,imageGif].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            
            sendPostButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            sendPostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            sendPostButton.heightAnchor.constraint(equalToConstant: 30),
            sendPostButton.widthAnchor.constraint(equalToConstant: 110),
            
            imageUser.topAnchor.constraint(equalTo: cancelButton.bottomAnchor,constant: 40),
            imageUser.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            imageUser.heightAnchor.constraint(equalToConstant: 50),
            imageUser.widthAnchor.constraint(equalToConstant: 50),
            
            customTextfield.topAnchor.constraint(equalTo: imageUser.bottomAnchor,constant: 20),
            customTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            customTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            customTextfield.heightAnchor.constraint(equalToConstant: 36),
            
            customImage.topAnchor.constraint(equalTo: customTextfield.bottomAnchor,constant: 20),
            customImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customImage.heightAnchor.constraint(equalToConstant: 420),
            customImage.widthAnchor.constraint(equalToConstant: 225),
            
            spinnerViewForPost.centerXAnchor.constraint(equalTo: sendPostButton.centerXAnchor),
            spinnerViewForPost.centerYAnchor.constraint(equalTo: sendPostButton.centerYAnchor),
  
            customAddPhotoButton.centerYAnchor.constraint(equalTo: imageUser.centerYAnchor),
            customAddPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            imageGif.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageGif.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageGif.widthAnchor.constraint(equalToConstant: 100),
            imageGif.heightAnchor.constraint(equalToConstant: 100)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            self.sendPostButton.backgroundColor = #colorLiteral(red: 0.1758851111, green: 0.5897727013, blue: 0.9195605516, alpha: 1)
            textView.textColor = UIColor.createColor(light: .black, dark: .white)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что нового?"
            self.sendPostButton.backgroundColor = #colorLiteral(red: 0.6288032532, green: 0.868211925, blue: 1, alpha: 1)
            textView.textColor = UIColor.lightGray
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

extension MessagePostViewController {
    func tapScreen() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
