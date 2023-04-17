//
//  StartMatchView.swift
//  Juls
//
//  Created by Fanil_Jr on 02.04.2023.
//

import Foundation
import UIKit
import Firebase

protocol StartMatchProtocol: AnyObject {
    func start()
}
class StartMatchView: UIView {
    
    var user: User?
    var delegate: StartMatchProtocol?
    
    var imageUser: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 150/2
        image.alpha = 0.0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let iwantLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Поиграем в любовь?"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 16)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 0.0
        i.clipsToBounds = true
        return i
    }()
    
    lazy var loveLabel: UILabel = {
        let love = UILabel()
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapLove))
        love.addGestureRecognizer(gesture)
        love.translatesAutoresizingMaskIntoConstraints = false
        love.text = "YES"
        love.isUserInteractionEnabled = true
        love.textColor = UIColor.createColor(light: .black, dark: .white)
        love.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        love.font = UIFont(name: "Futura-Bold", size: 20)
        love.shadowOffset = CGSize(width: 1, height: 1)
        love.alpha = 0.0
        love.clipsToBounds = true
        return love
    }()
    
    private let mainLabel: UILabel = {
        let friend = UILabel()
        friend.translatesAutoresizingMaskIntoConstraints = false
        friend.text = "Juls Match"
        friend.textColor = UIColor.createColor(light: .black, dark: .white)
        friend.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        friend.font = UIFont(name: "Futura-Bold", size: 30)
        friend.shadowOffset = CGSize(width: 1, height: 1)
        friend.alpha = 0.0
        friend.clipsToBounds = true
        return friend
    }()
    
    private let imageOne: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.alpha = 0.0
        image.image = UIImage(named: "png1")
        image.clipsToBounds = true
        return image
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapLove() {
        guard let uid = user?.uid else { return }
        guard let user = user else { return }
        let value = ["isActiveMatch": true]
        Database.database().reference().child("users").child(uid).updateChildValues(value) { error, _ in
            if let error {
                print(error)
                return
            }
            print("succes update isActiveMatch = true, user:", user.username)
            UIView.animate(withDuration: 1) {
                self.imageUser.transform = CGAffineTransform(translationX: 0, y: -600)
                self.iwantLabel.transform = CGAffineTransform(translationX: 0, y: -600)
                self.iwantLabel.alpha = 0.0
            }
            UIView.animate(withDuration: 0.5, delay: 0.5) {
                self.loveLabel.transform = CGAffineTransform(translationX: 0, y: -900)
                self.imageOne.transform = CGAffineTransform(translationX: 0, y: -900)
                self.imageOne.alpha = 0.0
            }
            UIView.animate(withDuration: 0.5, delay: 0.7) {
                self.mainLabel.transform = CGAffineTransform(translationX: 0, y: 100)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.delegate?.start()
            })
        }
    }
    
    func startAnimate() {
        UIView.animate(withDuration: 1.5) {
            self.imageUser.alpha = 1
            self.imageUser.transform = CGAffineTransform(translationX: 0, y: -200)
            self.iwantLabel.alpha = 1
            self.iwantLabel.transform = CGAffineTransform(translationX: 0, y: -200)
        }
        
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.mainLabel.alpha = 1
            self.loveLabel.alpha = 1
            self.imageOne.alpha = 1
            self.imageOne.transform = CGAffineTransform(translationX: 0, y: -200)
            self.loveLabel.transform = CGAffineTransform(translationX: 0, y: -200)
            self.mainLabel.transform = CGAffineTransform(translationX: 0, y: -200)
        }
    }
    
    func layout() {
        [imageUser,iwantLabel,imageOne,loveLabel,mainLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageUser.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageUser.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageUser.heightAnchor.constraint(equalToConstant: 150),
            imageUser.widthAnchor.constraint(equalToConstant: 150),
            
            iwantLabel.topAnchor.constraint(equalTo: imageUser.bottomAnchor,constant: 15),
            iwantLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageOne.topAnchor.constraint(equalTo: iwantLabel.bottomAnchor,constant: 50),
            imageOne.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageOne.heightAnchor.constraint(equalToConstant: 110),
            imageOne.widthAnchor.constraint(equalToConstant: 150),
            
            loveLabel.centerXAnchor.constraint(equalTo: imageOne.centerXAnchor),
            loveLabel.centerYAnchor.constraint(equalTo: imageOne.centerYAnchor),
            loveLabel.heightAnchor.constraint(equalToConstant: 40),
            
            mainLabel.topAnchor.constraint(equalTo: imageOne.bottomAnchor,constant: 40),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
