//
//  MatchView.swift
//  Juls
//
//  Created by Fanil_Jr on 02.04.2023.
//

import Foundation
import UIKit
import ImageIO

protocol MatchViewProtocol: AnyObject {
    func tapLike(completion: @escaping (Error?) -> Void)
    func tapDissLike()
}

class MatchView: UIView {
    
    var users = [User]()
    var delegate: MatchViewProtocol?
    
    let likeGif = UIImage.gifImageWithName("smiling_face_with_heart_eyes")
    let dissLikeGif = UIImage.gifImageWithName("unamused_face")
    
    var gifLikeImageView: UIImageView = {
        let gif = UIImageView()
        gif.contentMode = .scaleAspectFill
        gif.translatesAutoresizingMaskIntoConstraints = false
        return gif
    }()
    
    var gifDissLikeImageView: UIImageView = {
        let gif = UIImageView()
        gif.contentMode = .scaleAspectFill
        gif.translatesAutoresizingMaskIntoConstraints = false
        return gif
    }()
    
    var imageUser: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.image = UIImage(named: "Black")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    var name: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont(name: "Futura-Bold", size: 25)
        name.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        name.shadowOffset = CGSize(width: 1, height: 1)
        return name
    }()
    
    var moneyImage: UIImageView = {
        let money = UIImageView()
        money.image = UIImage(systemName: "rublesign.circle.fill")
        money.translatesAutoresizingMaskIntoConstraints = false
        money.contentMode = .scaleAspectFill
        money.tintColor = #colorLiteral(red: 0.6754702926, green: 0.5575380325, blue: 0.4061277211, alpha: 1)
        return money
    }()
    
    var money: UILabel = {
        let money = UILabel()
        money.translatesAutoresizingMaskIntoConstraints = false
        money.text = "300.00"
        money.font = UIFont(name: "Futura-Bold", size: 14)
        money.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        money.shadowOffset = CGSize(width: 1, height: 1)
        return money
    }()
    
    lazy var likeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapLike))
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "1f60d")
        return image
    }()
    
    lazy var dissLikeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapDissLike))
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        image.image = UIImage(named: "1f612")
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
    
    @objc func tapLike() {
        self.likeImage.alpha = 0.0
        self.gifLikeImageView.image = likeGif
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.likeImage.alpha = 1.0
            self.gifLikeImageView.image = UIImage()
        })
        
        delegate?.tapLike(completion: { error in
            if let error {
                print(error)
                return
            }
        })
    }
    
    @objc func tapDissLike() {
        self.dissLikeImage.alpha = 0.0
        self.gifDissLikeImageView.image = dissLikeGif
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.dissLikeImage.alpha = 1.0
            self.gifDissLikeImageView.image = UIImage()
        })
        delegate?.tapDissLike()
    }
    
    func layout() {
        [name,moneyImage,money,imageUser,dissLikeImage,likeImage,gifLikeImageView,gifDissLikeImageView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            name.centerYAnchor.constraint(equalTo: money.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            
            moneyImage.topAnchor.constraint(equalTo: topAnchor),
            moneyImage.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            moneyImage.heightAnchor.constraint(equalToConstant: 20),
            moneyImage.widthAnchor.constraint(equalToConstant: 20),
            
            money.centerYAnchor.constraint(equalTo: moneyImage.centerYAnchor),
            money.trailingAnchor.constraint(equalTo: moneyImage.leadingAnchor,constant: -2),
            
            imageUser.topAnchor.constraint(equalTo: moneyImage.bottomAnchor,constant: 20),
            imageUser.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            imageUser.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            imageUser.heightAnchor.constraint(lessThanOrEqualToConstant: 510),
            
            dissLikeImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -60),
            dissLikeImage.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 80),
            dissLikeImage.heightAnchor.constraint(equalToConstant: 60),
            dissLikeImage.widthAnchor.constraint(equalToConstant: 60),
            
            likeImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -60),
            likeImage.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -80),
            likeImage.heightAnchor.constraint(equalToConstant: 60),
            likeImage.widthAnchor.constraint(equalToConstant: 60),
            
            gifLikeImageView.centerXAnchor.constraint(equalTo: likeImage.centerXAnchor),
            gifLikeImageView.centerYAnchor.constraint(equalTo: likeImage.centerYAnchor),
            gifLikeImageView.heightAnchor.constraint(equalToConstant: 80),
            gifLikeImageView.widthAnchor.constraint(equalToConstant: 80),
            
            gifDissLikeImageView.centerYAnchor.constraint(equalTo: dissLikeImage.centerYAnchor),
            gifDissLikeImageView.centerXAnchor.constraint(equalTo: dissLikeImage.centerXAnchor),
            gifDissLikeImageView.heightAnchor.constraint(equalToConstant: 80),
            gifDissLikeImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
}
