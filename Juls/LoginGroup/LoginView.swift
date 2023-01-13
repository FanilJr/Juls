//
//  LoginView.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit
import Firebase

class LoginView: UIView {

    weak var delegate: LogInViewControllerDelegate?
    weak var checkerDelegate: LogInViewControllerCheckerDelegate?
    private let nc = NotificationCenter.default

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var lineUp: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .darkGray
        line.alpha = 0.5
        line.contentMode = .scaleAspectFill
        line.layer.cornerRadius = 3
        line.clipsToBounds = true
        return line
    }()
    
    private let faceidImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "faceid@100x")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let labelOR: UILabel = {
        let label = UILabel()
        label.text = "или"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loginTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Login or email", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return textField
    }()

    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.isSecureTextEntry = true
        textField.tintColor = UIColor(named: "#4885CC")
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return textField
    }()

    lazy var logInButton: CustomButton = {
        logInButton = CustomButton(title: "Вход", titleColor: .white, onTap: { [weak self] in
                self?.tappedButton()
            })
        logInButton.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        logInButton.layer.cornerRadius = 10
        logInButton.clipsToBounds = true
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        return logInButton
    }()
    
    private lazy var registrationButton: CustomButton = {
        registrationButton = CustomButton(title: "Регистрация", titleColor: .white, onTap: { [weak self] in
                self?.signUpTapped()
            })
        registrationButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        registrationButton.layer.cornerRadius = 10
        registrationButton.clipsToBounds = true
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        return registrationButton
    }()
    
    private lazy var biometryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.337697003, green: 0.2437653602, blue: 0.3948322499, alpha: 1)
        button.setTitle("Вход через FaceID", for: .normal)
        button.addTarget(self, action: #selector(biometryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addObserver()
        tapScreen()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObserver()
    }

    func addObserver() {
        nc.addObserver(self, selector: #selector(kdbShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kdbHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeObserver() {
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func kdbShow(notification: NSNotification) {
        
        if let kdbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = kdbSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kdbSize.height, right: 0)
        }
    }

    @objc func kdbHide() {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    private func tappedButton() {
        guard let vc = self.window?.rootViewController else { return }

        guard let emailText = loginTextField.text, !emailText.isEmpty else {
            CommonAlertError.present(vc: vc, with: "Input correct email")
            return
        }
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            CommonAlertError.present(vc: vc, with: "Input correct password")
            return
        }
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { user, error in
            if let error {
                CommonAlertError.present(vc: vc, with: error.localizedDescription)
                print("suda zashli")
                return
            }
            print("succes Login", user?.user.uid as Any)
            self.delegate?.tappedButton()
        }
    }

    
    private func signUpTapped() {
        delegate?.pushSignUp()
    }
    
    @objc private func biometryTapped() {
        guard let vc = self.window?.rootViewController else { return }

        let local = LocalAuthorizationService()
        local.authorizeIfPossible { [weak self] flag in
            if flag {
                self?.delegate?.tappedButton()
            } else {
                CommonAlertError.present(vc: vc, with: "Error in biometry authorized!")
            }
        }
    }
    
    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }

    private func layout() {
        
        [loginTextField, passwordTextField, logInButton, labelOR, registrationButton, biometryButton].forEach { contentView.addSubview($0) }
        biometryButton.addSubview(faceidImage)
        scrollView.addSubview(contentView)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            loginTextField.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 340),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 45),
            
            labelOR.topAnchor.constraint(equalTo: logInButton.bottomAnchor,constant: 16),
            labelOR.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            biometryButton.topAnchor.constraint(equalTo: labelOR.bottomAnchor,constant: 16),
            biometryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            biometryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            biometryButton.heightAnchor.constraint(equalToConstant: 45),
            
            faceidImage.centerYAnchor.constraint(equalTo: biometryButton.centerYAnchor),
            faceidImage.leadingAnchor.constraint(equalTo: biometryButton.leadingAnchor,constant: 5),
            faceidImage.heightAnchor.constraint(equalToConstant: 35),
            faceidImage.widthAnchor.constraint(equalToConstant: 35),

            registrationButton.topAnchor.constraint(equalTo: biometryButton.bottomAnchor,constant: 160),
            registrationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            registrationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            registrationButton.heightAnchor.constraint(equalToConstant: 45),
            registrationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}


extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}

extension LoginView {
    func tapScreen() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
    }
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

