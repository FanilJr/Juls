//
//  RegistrationViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit
import Firebase

class RegistratonViewController: UIViewController {
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Укажите Email", textColor: .black, font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Придумайте пароль", textColor: .black, font: UIFont.systemFont(ofSize: 16))
        textField.tintColor = UIColor(named: "#4885CC")
        textField.layer.cornerRadius = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var userNameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Придумайте логин", textColor: .black, font: UIFont.systemFont(ofSize: 16))
        textField.tintColor = UIColor(named: "#4885CC")
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        let registration = UIButton()
        registration.backgroundColor = .black
        registration.layer.cornerRadius = 10
        registration.layer.masksToBounds = true
        registration.translatesAutoresizingMaskIntoConstraints = false
        registration.addTarget(self, action: #selector(registrationTapet), for: .touchUpInside)
        return registration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func registrationTapet() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = userNameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        let alertController = UIAlertController(title: "Браво 👏", message: "Вы успешно прошли регистрацию!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertAction)
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error {
                print("Failed create", error)
                return
            }
            print("Succes create", user?.user.uid as Any)
            
            guard let uid = user?.user.uid else { return }
            
            let allValues = ["username": username, "name": "","secondName": "","picture": "", "years": "", "status": "", "life status": "", "height": ""]
            let values = [uid: allValues]
            
            Database.database().reference().child("users").updateChildValues(values) { error, ref in
                if let error {
                    print("failed ooooops", error)
                }

                print("succes update user info")
                self.present(alertController, animated: true)
            }
        }
    }
    
    private func layout() {
        [emailTextField,passwordTextField,userNameTextField,registrationButton].forEach { view.addSubview($0) }
            
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor,constant: 340),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            userNameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            userNameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            registrationButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor,constant: 16),
            registrationButton.heightAnchor.constraint(equalToConstant: 45),
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16)
        ])
    }
}
