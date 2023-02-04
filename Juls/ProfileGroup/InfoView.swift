//
//  InfoView.swift
//  Juls
//
//  Created by Fanil_Jr on 05.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol InfoDelegate: AnyObject {
    func saveInfo()
    func cancelSave()
}

class InfoView: UIView {
    
    weak var delegateInfo: InfoDelegate?
    private var statusText: String = ""
    private var datePicker = UIDatePicker()
    
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
    
    lazy var imageAccaunt: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "1")
        image.layer.cornerRadius = 150/2
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 1
        image.clipsToBounds = true
        return image
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
        settings.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
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
        settings.addTarget(self, action: #selector(cancelSave), for: .touchUpInside)
        return settings
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        layoutView()
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 30
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 30
        nameTextField.delegate = self
        secondNameTextField.delegate = self
        ageTextField.delegate = self
        statusLifeTextField.delegate = self
        heightTextField.delegate = self
        otherTextField.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        [nameTextField, secondNameTextField, ageTextField, statusLifeTextField, heightTextField, viewAccaunt, saveButton, cancelButton].forEach { addSubview($0) }
        
        [name, secondName, age, statusLife, height].forEach { viewAccaunt.addSubview($0) }
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: topAnchor),
            nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            nameTextField.widthAnchor.constraint(equalTo: widthAnchor),
            
            secondNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 10),
            secondNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40),
            secondNameTextField.widthAnchor.constraint(equalTo: widthAnchor),
            
            ageTextField.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor,constant: 10),
            ageTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),
            ageTextField.widthAnchor.constraint(equalTo: widthAnchor),
            
            statusLifeTextField.topAnchor.constraint(equalTo: ageTextField.bottomAnchor,constant: 10),
            statusLifeTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLifeTextField.heightAnchor.constraint(equalToConstant: 40),
            statusLifeTextField.widthAnchor.constraint(equalTo: widthAnchor),
            
            heightTextField.topAnchor.constraint(equalTo: statusLifeTextField.bottomAnchor,constant: 10),
            heightTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            heightTextField.heightAnchor.constraint(equalToConstant: 40),
            heightTextField.widthAnchor.constraint(equalTo: widthAnchor),
            
            viewAccaunt.topAnchor.constraint(equalTo: heightTextField.bottomAnchor,constant: 20),
            viewAccaunt.widthAnchor.constraint(equalTo: widthAnchor),
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
            
            saveButton.topAnchor.constraint(equalTo: viewAccaunt.bottomAnchor,constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalTo: widthAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor,constant: 15),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
    
    @objc func cancelSave() {
        delegateInfo?.cancelSave()
    }
    
    @objc func tapSave() {
        delegateInfo?.saveInfo()
    }
}

extension InfoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !statusText.isEmpty else {
      
            self.name.text = self.nameTextField.text
            self.secondName.text = self.secondNameTextField.text
            self.age.text = self.ageTextField.text
            self.statusLife.text = self.statusLifeTextField.text
            self.height.text = self.heightTextField.text
            self.other.text = self.otherTextField.text
            
            print("Статус установлен")
            endEditing(true)
            return true
        }
        return true
    }
}
