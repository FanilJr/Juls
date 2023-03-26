//
//  MatchViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 20.03.2023.
//

import Foundation
import UIKit
import Firebase

class MatchViewController: UIViewController {
    
    var user: User?
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alpha = 0.0
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private var imageUser: CustomImageView = {
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
        i.text = "Я здесь чтобы..."
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
        love.text = "Влюбиться"
        love.isUserInteractionEnabled = true
        love.textColor = UIColor.createColor(light: .black, dark: .white)
        love.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        love.font = UIFont(name: "Futura-Bold", size: 20)
        love.shadowOffset = CGSize(width: 1, height: 1)
        love.alpha = 0.0
        love.clipsToBounds = true
        return love
    }()
    
    private let friendLabel: UILabel = {
        let friend = UILabel()
        friend.translatesAutoresizingMaskIntoConstraints = false
        friend.text = "Познакомиться"
        friend.textColor = UIColor.createColor(light: .black, dark: .white)
        friend.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        friend.font = UIFont(name: "Futura-Bold", size: 18)
        friend.shadowOffset = CGSize(width: 1, height: 1)
        friend.alpha = 0.0
        friend.clipsToBounds = true
        return friend
    }()
    
    private let talkLabel: UILabel = {
        let friend = UILabel()
        friend.translatesAutoresizingMaskIntoConstraints = false
        friend.text = "Общаться"
        friend.textColor = UIColor.createColor(light: .black, dark: .white)
        friend.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        friend.font = UIFont(name: "Futura-Bold", size: 18)
        friend.shadowOffset = CGSize(width: 1, height: 1)
        friend.alpha = 0.0
        friend.clipsToBounds = true
        return friend
    }()
    
    private let otherLabel: UILabel = {
        let friend = UILabel()
        friend.translatesAutoresizingMaskIntoConstraints = false
        friend.text = "Другое"
        friend.textColor = UIColor.createColor(light: .black, dark: .white)
        friend.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        friend.font = UIFont(name: "Futura-Bold", size: 18)
        friend.shadowOffset = CGSize(width: 1, height: 1)
        friend.alpha = 0.0
        friend.clipsToBounds = true
        return friend
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
    
    private let imageTwo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.alpha = 0.0
        image.image = UIImage(named: "png2")
        image.clipsToBounds = true
        return image
    }()
    
    private let imageThree: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.alpha = 0.0
        image.image = UIImage(named: "png5")
        image.clipsToBounds = true
        return image
    }()
    
    private let imageFour: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.alpha = 0.0
        image.image = UIImage(named: "png4")
        image.clipsToBounds = true
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Match"
        setupDidLoad()
    }
    
    @objc func tapLove() {
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
            self.friendLabel.transform = CGAffineTransform(translationX: 0, y: -900)
            self.imageTwo.transform = CGAffineTransform(translationX: 0, y: -900)
            self.mainLabel.transform = CGAffineTransform(translationX: 0, y: 100)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.9) {
            self.talkLabel.transform = CGAffineTransform(translationX: 0, y: -1200)
            self.imageThree.transform = CGAffineTransform(translationX: 0, y: -1200)
        }
        
        UIView.animate(withDuration: 0.5, delay: 1.1) {
            self.otherLabel.transform = CGAffineTransform(translationX: 0, y: -1400)
            self.imageFour.transform = CGAffineTransform(translationX: 0, y: -1400)
        }
    }
    
    func setupDidLoad() {
        fetchUser()
        layout()
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
            self.friendLabel.alpha = 1
            self.talkLabel.alpha = 1
            self.otherLabel.alpha = 1
            
            self.imageOne.alpha = 1
            self.imageTwo.alpha = 1
            self.imageThree.alpha = 1
            self.imageFour.alpha = 1
            
            self.imageThree.transform = CGAffineTransform(translationX: 0, y: -200)
            self.imageTwo.transform = CGAffineTransform(translationX: 0, y: -200)
            self.imageOne.transform = CGAffineTransform(translationX: 0, y: -200)
            self.imageFour.transform = CGAffineTransform(translationX: 0, y: -200)
            
            self.loveLabel.transform = CGAffineTransform(translationX: 0, y: -200)
            self.friendLabel.transform = CGAffineTransform(translationX: 0, y: -200)
            self.talkLabel.transform = CGAffineTransform(translationX: 0, y: -200)
            self.otherLabel.transform = CGAffineTransform(translationX: 0, y: -200)
            
            self.mainLabel.transform = CGAffineTransform(translationX: 0, y: -200)
        }
    }
    
    func layout() {
        [tableView,imageUser,iwantLabel,imageOne,imageTwo,imageThree,imageFour,loveLabel,friendLabel,talkLabel,otherLabel,mainLabel].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageUser.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageUser.heightAnchor.constraint(equalToConstant: 150),
            imageUser.widthAnchor.constraint(equalToConstant: 150),
            
            iwantLabel.topAnchor.constraint(equalTo: imageUser.bottomAnchor,constant: 15),
            iwantLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageOne.topAnchor.constraint(equalTo: iwantLabel.bottomAnchor,constant: 50),
            imageOne.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            imageOne.heightAnchor.constraint(equalToConstant: 110),
            imageOne.widthAnchor.constraint(equalToConstant: 150),
            
            imageTwo.topAnchor.constraint(equalTo: iwantLabel.bottomAnchor,constant: 70),
            imageTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            imageTwo.heightAnchor.constraint(equalToConstant: 110),
            imageTwo.widthAnchor.constraint(equalToConstant: 180),
            
            imageThree.topAnchor.constraint(equalTo: imageOne.bottomAnchor,constant: 20),
            imageThree.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            imageThree.heightAnchor.constraint(equalToConstant: 110),
            imageThree.widthAnchor.constraint(equalToConstant: 190),
            
            imageFour.topAnchor.constraint(equalTo: imageTwo.bottomAnchor,constant: 30),
            imageFour.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            imageFour.heightAnchor.constraint(equalToConstant: 110),
            imageFour.widthAnchor.constraint(equalToConstant: 150),
            
            loveLabel.centerXAnchor.constraint(equalTo: imageOne.centerXAnchor),
            loveLabel.centerYAnchor.constraint(equalTo: imageOne.centerYAnchor),
            loveLabel.heightAnchor.constraint(equalToConstant: 40),
            
            friendLabel.centerXAnchor.constraint(equalTo: imageTwo.centerXAnchor),
            friendLabel.centerYAnchor.constraint(equalTo: imageTwo.centerYAnchor),
            friendLabel.heightAnchor.constraint(equalToConstant: 40),
            
            talkLabel.centerYAnchor.constraint(equalTo: imageThree.centerYAnchor),
            talkLabel.centerXAnchor.constraint(equalTo: imageThree.centerXAnchor),
            talkLabel.heightAnchor.constraint(equalToConstant: 40),
            
            otherLabel.centerXAnchor.constraint(equalTo: imageFour.centerXAnchor),
            otherLabel.centerYAnchor.constraint(equalTo: imageFour.centerYAnchor),
            otherLabel.heightAnchor.constraint(equalToConstant: 40),
            
            mainLabel.topAnchor.constraint(equalTo: imageFour.bottomAnchor,constant: 40),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: uid) { user in
            DispatchQueue.main.async {
                self.user = user
                if user.isActiveMatch {
                    self.tableView.alpha = 1
                    print("active Match")
                } else {
                    self.startAnimate()
                    print("no active Match")
                }
                self.imageUser.loadImage(urlString: user.picture)
            }
        }
    }
}
