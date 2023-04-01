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

    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        logo.layer.cornerRadius = 30
        return logo
    }()
    
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
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Введите email", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return textField
    }()
    
    private lazy var passRegisterTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Придумайте пароль"
        textField.textColor = UIColor.createColor(light: .black, dark: .white)
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 0.5
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:self.frame.height))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var nickNameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Придумайте никнейм", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .emailAddress
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
    
    lazy var registerButton: CustomButton = {
        registerButton = CustomButton(title: "Зарегистрироваться", titleColor: .white, onTap: { [weak self] in
                self?.tappedRegister()
            })
        registerButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        return registerButton
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
    
    private lazy var backButton: CustomButton = {
        backButton = CustomButton(title: "", titleColor: .white, onTap: { [weak self] in
                self?.backUpButton()
            })
        backButton.setBackgroundImage(UIImage(systemName: "arrow.backward.circle.fill"), for: .normal)
        backButton.layer.cornerRadius = 10
        backButton.clipsToBounds = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
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
    
    private func tappedRegister() {
        guard let vc = self.window?.rootViewController else { return }
        
        guard let mailText = emailTextField.text, !mailText.isEmpty else {
            CommonAlertError.present(vc: vc, with: "Input correct email")
            return
        }
        guard let passwordRegText = passRegisterTextField.text, !passwordRegText.isEmpty else {
            CommonAlertError.present(vc: vc, with: "Input correct password")
            return
        }
        guard let nicknameText = nickNameTextField.text, !nicknameText.isEmpty else {
            CommonAlertError.present(vc: vc, with: "Input correct nickname")
            return
        }
            
        Auth.auth().createUser(withEmail: mailText, password: passwordRegText) { user, error in
            if let error {
                print("Failed create", error)
                return
            }
            print("Succes create", user?.user.uid as Any)
            self.registerButton.backgroundColor = .systemGray6
            self.registerButton.isEnabled = true
            guard let uid = user?.user.uid else { return }
            
            let allValues = ["username": nicknameText, "name": "","sex": "","secondName": "","picture": "", "age": Int(), "status": "", "life status": "", "official": Bool()]
            let values = [uid: allValues]
            
            Database.database().reference().child("users").updateChildValues(values) { error, ref in
                if let error {
                    print("failed ooooops", error)
                    return
                }
                let allValues = ["rating": 0.0,"commentsRating": 0.0,"postsRating": 0.0,"userProfileRating": 0.0,"likeRating": 0.0,"timeRating": 0.0,"messagesRating": 0.0,"getComments": 0.0,"getMessages": 0.0]
                let values = [uid: allValues]
                Database.database().reference().child("rating").updateChildValues(values) { error, ref in
                    if let error {
                        print(error)
                        return
                    }
                    print("succes update user info")
                
                
                
    //______________________________________________________________________________________________________\\
                
                    Auth.auth().signIn(withEmail: mailText, password: passwordRegText) { user, error in
                        if let error {
                            CommonAlertError.present(vc: vc, with: error.localizedDescription)
                            print(error)
                            return
                        }
                        guard let userId = user?.user.uid else { return }
                        print("succes Login", userId as Any)
                        self.registerButton.isEnabled = false
                        self.registerButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                        self.backUpButton()
                        self.delegate?.tappedRegister()
                    }
                }
            }
        }
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
                print(error)
                return
            }
            guard let userId = user?.user.uid else { return }
            print("succes Login", userId as Any)
            self.delegate?.tappedButton()
        }
    }

    
    private func signUpTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loginTextField.transform = CGAffineTransform(translationX: -400, y: 0)
            self.passwordTextField.transform = CGAffineTransform(translationX: -400, y: 0)
            self.logInButton.transform = CGAffineTransform(translationX: -400, y: 0)
            self.registrationButton.transform = CGAffineTransform(translationX: -400, y: 0)
            
            self.emailTextField.transform = CGAffineTransform(translationX: -380, y: 0)
            self.passRegisterTextField.transform = CGAffineTransform(translationX: -380, y: 0)
            self.nickNameTextField.transform = CGAffineTransform(translationX: -380, y: 0)
            self.registerButton.transform = CGAffineTransform(translationX: -380, y: 0)
            
            self.backButton.transform = CGAffineTransform(translationX: 50, y: 0)
        })
    }
    
    private func backUpButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backButton.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.emailTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.passRegisterTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.nickNameTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.registerButton.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.loginTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.logInButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.registrationButton.transform = CGAffineTransform(translationX: 0, y: 0)
            
        })
    }
    
    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }

    private func layout() {
        
        [logo, loginTextField, passwordTextField, logInButton, registrationButton, emailTextField, passRegisterTextField, nickNameTextField, registerButton, backButton].forEach { contentView.addSubview($0) }
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
            
            logo.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 120),
            logo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 150),
            logo.widthAnchor.constraint(equalToConstant: 150),

            loginTextField.topAnchor.constraint(equalTo: logo.bottomAnchor,constant: 90),
            loginTextField.widthAnchor.constraint(equalToConstant: 350),
            loginTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 350),
            passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 16),
            logInButton.widthAnchor.constraint(equalToConstant: 350),
            logInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 45),
            
            registrationButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor,constant: 277),
            registrationButton.widthAnchor.constraint(equalToConstant: 350),
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.heightAnchor.constraint(equalToConstant: 45),
            registrationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 60),
            backButton.trailingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: logo.bottomAnchor,constant: 90),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 350),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passRegisterTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passRegisterTextField.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
            passRegisterTextField.widthAnchor.constraint(equalToConstant: 350),
            passRegisterTextField.heightAnchor.constraint(equalToConstant: 45),
            
            nickNameTextField.topAnchor.constraint(equalTo: passRegisterTextField.bottomAnchor),
            nickNameTextField.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nickNameTextField.widthAnchor.constraint(equalToConstant: 350),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            registerButton.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor,constant: 100),
            registerButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 350),
            registerButton.heightAnchor.constraint(equalToConstant: 45)
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
