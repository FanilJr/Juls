//
//  GameStartView.swift
//  Juls
//
//  Created by Fanil_Jr on 13.04.2023.
//

import Foundation
import UIKit

protocol GameStartProtocol: AnyObject {
    func start()
}

class GameStartView: UIView {
    
    var user: User?
    weak var delegate: GameStartProtocol?
    
    var imageUser: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 150/2
        image.alpha = 0.0
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let gameLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Начнём игру?"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 16)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 0.0
        i.clipsToBounds = true
        return i
    }()
    
    lazy var yesLabel: UILabel = {
        let love = UILabel()
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(startGame))
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
    
    private let imageOne: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.alpha = 0.0
        image.image = UIImage(named: "png5")
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
    
    @objc func startGame() {
        UIView.animate(withDuration: 1) {
            self.imageUser.transform = CGAffineTransform(translationX: 0, y: -600)
            self.gameLabel.transform = CGAffineTransform(translationX: 0, y: -600)
            self.gameLabel.alpha = 0.0
        }
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.yesLabel.transform = CGAffineTransform(translationX: 0, y: -900)
            self.imageOne.transform = CGAffineTransform(translationX: 0, y: -900)
            self.imageOne.alpha = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.delegate?.start()
        })
    }
    
    func startAnimate() {
        UIView.animate(withDuration: 1.5) {
            self.imageUser.alpha = 1
            self.imageUser.transform = CGAffineTransform(translationX: 0, y: -200)
            self.gameLabel.alpha = 1
            self.gameLabel.transform = CGAffineTransform(translationX: 0, y: -200)
        }
        
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.yesLabel.alpha = 1
            self.imageOne.alpha = 1
            self.imageOne.transform = CGAffineTransform(translationX: 0, y: -200)
            self.yesLabel.transform = CGAffineTransform(translationX: 0, y: -200)
        }
    }
    
    func layout() {
        [imageUser,gameLabel,imageOne,yesLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageUser.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageUser.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageUser.heightAnchor.constraint(equalToConstant: 150),
            imageUser.widthAnchor.constraint(equalToConstant: 150),
            
            gameLabel.topAnchor.constraint(equalTo: imageUser.bottomAnchor,constant: 20),
            gameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageOne.topAnchor.constraint(equalTo: gameLabel.bottomAnchor,constant: 40),
            imageOne.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageOne.heightAnchor.constraint(equalToConstant: 130),
            imageOne.widthAnchor.constraint(equalToConstant: 210),
            
            yesLabel.centerXAnchor.constraint(equalTo: imageOne.centerXAnchor),
            yesLabel.centerYAnchor.constraint(equalTo: imageOne.centerYAnchor)
        ])
    }
}
