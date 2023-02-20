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
    
    let viewAccaunt: UIView = {
        let viewAccaunt = UIView()
        viewAccaunt.backgroundColor = UIColor.createColor(light: .white, dark: .systemGray6)
        viewAccaunt.translatesAutoresizingMaskIntoConstraints = false
        viewAccaunt.clipsToBounds = true
        viewAccaunt.isUserInteractionEnabled = true
        viewAccaunt.layer.borderColor = UIColor.white.cgColor
        viewAccaunt.layer.borderWidth = 1
        viewAccaunt.layer.cornerRadius = 14
        return viewAccaunt
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
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
        button.addTarget(SettingsViewController.self, action: #selector(changeAvatar), for: .touchUpInside)
        button.setTitle("Редактировать", for: .normal)
        return button
    }()
    
    let stackTextField: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 0
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let stackLabels: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Имя", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.returnKeyType = .continue
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var secondNameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Фамилия", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.layer.borderWidth = 0.5
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    lazy var ageTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Возраст", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.layer.borderWidth = 0.5
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var statusLifeTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Семейное положение", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.returnKeyType = .continue
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var heightTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Рост", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.returnKeyType = .continue
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var otherTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Привычки", textColor: .createColor(light: .black, dark: .white), font: UIFont.systemFont(ofSize: 16))
        textField.backgroundColor = .systemGray6
        textField.tintColor = UIColor(named: "#4885CC")
        textField.returnKeyType = .done
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let name: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(light: .black, dark: .white)
        fullNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    let secondName: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(light: .black, dark: .white)
        fullNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    let height: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(light: .black, dark: .white)
        fullNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    let age: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(light: .black, dark: .white)
        fullNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    let statusLife: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(light: .black, dark: .white)
        fullNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    let other: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(light: .black, dark: .white)
        fullNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    let saveButton: UIButton = {
        let settings = UIButton()
        settings.setTitle("Сохранить", for: .normal)
        settings.setTitleColor(.white, for: .normal)
        settings.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        settings.tintColor = .cyan
        settings.layer.cornerRadius = 14
        settings.translatesAutoresizingMaskIntoConstraints = false
        settings.clipsToBounds = true
        return settings
    }()
    
    let cancelButton: UIButton = {
        let settings = UIButton()
        settings.setTitle("Отменить", for: .normal)
        settings.setTitleColor(.white, for: .normal)
        settings.backgroundColor = .red
        settings.tintColor = .cyan
        settings.layer.cornerRadius = 14
        settings.translatesAutoresizingMaskIntoConstraints = false
        settings.clipsToBounds = true
        return settings
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
        [background,avatarImageView,avatarChangeButton,spinnerView,nameTextField, secondNameTextField, ageTextField, statusLifeTextField, heightTextField,otherTextField, viewAccaunt, saveButton, cancelButton].forEach { view.addSubview($0) }
        
        [name, secondName, age, statusLife, height, other].forEach { viewAccaunt.addSubview($0) }
        
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
            spinnerView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: avatarChangeButton.bottomAnchor,constant: 10),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            nameTextField.widthAnchor.constraint(equalToConstant: 200),
//
            secondNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 10),
            secondNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40),
            secondNameTextField.widthAnchor.constraint(equalToConstant: 200),

            ageTextField.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor,constant: 10),
            ageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),
            ageTextField.widthAnchor.constraint(equalToConstant: 200),

            statusLifeTextField.topAnchor.constraint(equalTo: ageTextField.bottomAnchor,constant: 10),
            statusLifeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLifeTextField.heightAnchor.constraint(equalToConstant: 40),
            statusLifeTextField.widthAnchor.constraint(equalToConstant: 200),

            heightTextField.topAnchor.constraint(equalTo: statusLifeTextField.bottomAnchor,constant: 10),
            heightTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heightTextField.heightAnchor.constraint(equalToConstant: 40),
            heightTextField.widthAnchor.constraint(equalToConstant: 200),

            otherTextField.topAnchor.constraint(equalTo: heightTextField.bottomAnchor,constant: 10),
            otherTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otherTextField.heightAnchor.constraint(equalToConstant: 40),
            otherTextField.widthAnchor.constraint(equalToConstant: 200),

            viewAccaunt.topAnchor.constraint(equalTo: otherTextField.bottomAnchor,constant: 20),
            viewAccaunt.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewAccaunt.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewAccaunt.heightAnchor.constraint(equalToConstant: 200),

            name.topAnchor.constraint(equalTo: viewAccaunt.topAnchor,constant: 20),
            name.trailingAnchor.constraint(equalTo: viewAccaunt.trailingAnchor,constant: -10),

            secondName.topAnchor.constraint(equalTo: name.bottomAnchor,constant: 10),
            secondName.trailingAnchor.constraint(equalTo: viewAccaunt.trailingAnchor,constant: -10),

            age.topAnchor.constraint(equalTo: secondName.bottomAnchor,constant: 10),
            age.trailingAnchor.constraint(equalTo: viewAccaunt.trailingAnchor,constant: -10),

            statusLife.topAnchor.constraint(equalTo: age.bottomAnchor,constant: 10),
            statusLife.trailingAnchor.constraint(equalTo: viewAccaunt.trailingAnchor,constant: -10),

            height.topAnchor.constraint(equalTo: statusLife.bottomAnchor,constant: 10),
            height.trailingAnchor.constraint(equalTo: viewAccaunt.trailingAnchor,constant: -10),

            other.topAnchor.constraint(equalTo: height.bottomAnchor,constant: 10),
            other.trailingAnchor.constraint(equalTo: viewAccaunt.trailingAnchor,constant: -10),

            saveButton.topAnchor.constraint(equalTo: viewAccaunt.bottomAnchor,constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 300),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor,constant: 15),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
}

extension SettingsViewController {
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user

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

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        self.name.text = textField.text
            self.name.text = self.nameTextField.text
            self.secondName.text = self.secondNameTextField.text
            self.age.text = self.ageTextField.text
            self.statusLife.text = self.statusLifeTextField.text
            self.height.text = self.heightTextField.text
            self.other.text = self.otherTextField.text
            
            print("Статус установлен")
            textField.endEditing(true)
            return true
        }
    }


        
