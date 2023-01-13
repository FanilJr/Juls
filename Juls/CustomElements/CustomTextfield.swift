//
//  CustomTextfield.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

class CustomTextField: UITextField {

    init(placeholder: String, textColor: UIColor, font: UIFont) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setTextField(placeholder: placeholder, textColor: textColor, font: font)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTextField(placeholder: String, textColor: UIColor, font: UIFont) {
    
        self.font = font
        self.placeholder = placeholder
        self.textColor = textColor
        self.backgroundColor = .systemGray6
        self.autocapitalizationType = .none
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 14
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftViewMode = UITextField.ViewMode.always
        self.delegate = self
        self.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:self.frame.height))
        self.rightView = UIView(frame:CGRect(x:0, y:0, width:10, height:self.frame.height))
        self.rightViewMode = .always
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}

extension UITextField {
    
    func roundedTextField(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
