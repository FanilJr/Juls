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
    var raiting: Raiting?
    var users = [User]()
    var disslikeUsers = [User]()
    var startMatchView = StartMatchView()
    var matchView = MatchView()
    var matchUserView = MatchUserView()
    
    var currentIndex = 0
    var cgfloatTabBar: CGFloat?
    var tumblerForTransitionLeftorRight: Bool = true
    var balance = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Match"
        setupDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func showCurrentUser(users: [User]) {
        matchView.imageUser.image = UIImage(named: "Black")
        let currentUser = users[currentIndex]
        matchView.imageUser.loadImage(urlString: currentUser.picture)
        matchView.name.text = currentUser.name
    }
    
    func showCurrentUserContinue(users: [User]) {
        matchView.imageUser.image = UIImage(named: "Black")
        let currentUser = users[currentIndex]
        matchView.imageUser.loadImage(urlString: currentUser.picture)
        matchView.name.text = currentUser.name
        
        UIView.transition(with: matchView.imageUser, duration: 0.6, options: tumblerForTransitionLeftorRight ? .transitionFlipFromRight : .transitionFlipFromLeft) {
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.matchView.name.transform = CGAffineTransform(translationX: -150, y: 0)
        }
        UIView.animate(withDuration: 0.3, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.matchView.name.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    func setupDidLoad() {
        fetchUser()
        layout()
        startMatchView.delegate = self
        matchView.delegate = self
    }
        
    func layout() {
        matchView.alpha = 0
        [matchView,startMatchView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            matchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            matchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            matchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            matchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            startMatchView.topAnchor.constraint(equalTo: view.topAnchor),
            startMatchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startMatchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            startMatchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func getGender(user: User) {
        switch user.sex {
        case "Female":
            self.fetchUsersForGirls()
        case "Male":
            self.fetchUsersForBoys()
        default:
            print("no gender, but what???")
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: uid) { user in
            self.user = user
            self.matchView.money.text = "\(user.balance)"
            self.balance = user.balance
            DispatchQueue.main.async {
                if user.isActiveMatch {
                    self.startMatchView.removeFromSuperview()
                    print("active Match with \(user.username)")
                    self.getGender(user: user)
                    showOrAlpha(object: self.matchView, true, 0.4)
                } else {
                    self.startMatchView.user = user
                    self.startMatchView.imageUser.loadImage(urlString: user.picture)
                    self.startMatchView.startAnimate()
                }
            }
        }
    }
    
    func fetchUsersForBoys() {
        Database.database().fetchUserForLoveBoys { users in
            DispatchQueue.main.async {
                self.users = users
                self.showCurrentUser(users: users)
            }
        }
    }
    
    func fetchUsersForGirls() {
        Database.database().fetchUserForLoveGirls { users in
            DispatchQueue.main.async {
                self.users = users
                self.showCurrentUser(users: users)
                print(self.users.count)
            }
        }
    }
    
    func addEndMatchUserView() {
        print("hello")
        let endMatchUserView = EndMatchUserView()
        endMatchUserView.user = user
        endMatchUserView.delegate = self
        
        view.addSubview(endMatchUserView)
        
        NSLayoutConstraint.activate([
            endMatchUserView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            endMatchUserView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endMatchUserView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            endMatchUserView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        showOrAlpha(object: endMatchUserView, true, 0.4)
        showOrAlpha(object: matchView, false, 0.4)
    }
    
    func addMatchUserView() {
        matchUserView.user = users[currentIndex]
        matchUserView.delegate = self
        let currentUid = users[currentIndex].uid
        Database.database().fetchRaitingUser(withUID: currentUid) { raiting in
            self.raiting = raiting
            self.matchUserView.raiting = raiting
            self.view.addSubview(self.matchUserView)
            
            NSLayoutConstraint.activate([
                self.matchUserView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.matchUserView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.matchUserView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.matchUserView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
            showOrAlpha(object: self.matchUserView, true, 0.4)
            showOrAlpha(object: self.matchView, false, 0.4)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                showAnimate(mainObject: self, firstObject: self.matchUserView.matchLabel, objectSecond: self.matchUserView.nameUserLabel, alphaFirst: self.matchUserView.closedButton, alphaSecond: self.matchUserView.writeButton,alphaThree: self.matchUserView.addFriendButton, alphaFour: self.matchUserView.userRaiting,animate: true)
            })
        }
    }
}

extension MatchViewController: MatchUserViewProtocol {
    
    func tapImage() {
        let viewModel = ProfileViewModel()
        let vc = ProfileViewController(viewModel: viewModel)
        vc.userId = users[currentIndex].uid
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func write() {
        let chat = ChatViewController()
        chat.userFriend = users[currentIndex]
        chat.user = user
        navigationController?.pushViewController(chat, animated: true)
    }
    
    func addFriend() {
        print("setup add Friend")
    }
    
    func closed() {
        showOrAlpha(object: matchUserView, false, 0.4)
        showOrAlpha(object: matchView, true, 0.4)
        showAnimate(mainObject: self, firstObject: matchUserView.matchLabel, objectSecond: matchUserView.nameUserLabel, alphaFirst: self.matchUserView.closedButton, alphaSecond: self.matchUserView.writeButton, alphaThree: self.matchUserView.addFriendButton, alphaFour: self.matchUserView.userRaiting,animate: false)
        
        matchUserView.confettiGifImage.image = nil
        self.currentIndex += 1
        
        if self.currentIndex == self.users.count {
            self.addEndMatchUserView()
            print("Закончилось")
        } else {
            showCurrentUserContinue(users: self.users)
        }
    }
}

extension MatchViewController: StartMatchProtocol {
    func start() {
        self.fetchUser()
        print("start new LOVE story")
    }
}

extension MatchViewController: MatchViewProtocol {
    
    func tapLike(completion: @escaping (Error?) -> Void) {
        if balance == 0 {
            let alert = UIAlertController(title: "Ноу мани, ноу лайки", message: "соррян", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
            let addMoneyAction = UIAlertAction(title: "Пополнить",style: .cancel) { _ in
                print("add")
            }
            [cancelAction,addMoneyAction].forEach { alert.addAction($0) }
            navigationController?.present(alert, animated: true)
        } else {
            self.matchView.likeImage.isUserInteractionEnabled = false
            tumblerForTransitionLeftorRight = true
            balance -= 10
            self.matchView.money.text = "\(balance)"
            guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
            
            let values = ["balance": balance]
            Database.database().reference().child("users").child(currentLoggedInUserId).updateChildValues(values) { err, _ in
                if let err {
                    print(err)
                    return
                }
                
                guard let currentUserID = Auth.auth().currentUser?.uid else { return }
                let likeValue = ["MatchLike/\(currentUserID)/\(self.users[self.currentIndex].uid)": "Like",
                                 "MatchGetLike/\(self.users[self.currentIndex].uid)/\(currentUserID)": "GetLike"]
                Database.database().reference().updateChildValues(likeValue, withCompletionBlock: { error, _ in
                    if let error {
                        print("Error updating values: \(error.localizedDescription)")
                        completion(error)
                    } else {
                        print("Like successful!")
                        let matchLikeRef = Database.database().reference().child("MatchLike").child(self.users[self.currentIndex].uid)
                        let matchGetLikeRef = Database.database().reference().child("MatchGetLike").child(currentUserID)
                        matchLikeRef.observeSingleEvent(of: .value) { snapshot in
                            if snapshot.hasChild(currentUserID), let getLikeValue = snapshot.childSnapshot(forPath: currentUserID).value as? String, getLikeValue == "Like" {
                                matchGetLikeRef.observeSingleEvent(of: .value) { snapshot in
                                    if snapshot.hasChild(self.users[self.currentIndex].uid), let likeValue = snapshot.childSnapshot(forPath: self.users[self.currentIndex].uid).value as? String, likeValue == "GetLike" {
                                        print("It's a MATCH!!!!! \(self.user?.username ?? "") LOVE \(self.users[self.currentIndex].username) ❤️❤️❤️")
                                        self.matchView.likeImage.isUserInteractionEnabled = true
                                        self.addMatchUserView()
                                    }
                                }
                            } else {
                                self.currentIndex += 1
                                if self.currentIndex == self.users.count {
                                    self.addEndMatchUserView()
                                    print("Закончилось")
                                    self.matchView.likeImage.isUserInteractionEnabled = true
                                } else {
                                    self.matchView.likeImage.isUserInteractionEnabled = true
                                    self.showCurrentUserContinue(users: self.users)
                                    completion(nil)
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    func tapDissLike() {
        if balance == 0 {
            let alert = UIAlertController(title: "Ноу мани, ноу лайки", message: "соррян", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
            let addMoneyAction = UIAlertAction(title: "Пополнить", style: .cancel) { _ in
                print("add")
            }
            [cancelAction,addMoneyAction].forEach { alert.addAction($0) }
            navigationController?.present(alert, animated: true)
        } else {
            disslikeUsers.append(users[currentIndex])
            balance -= 10
            self.matchView.money.text = "\(balance)"
            guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
            
            let values = ["balance": balance]
            Database.database().reference().child("users").child(currentLoggedInUserId).updateChildValues(values) { err, _ in
                if let err {
                    print(err)
                    return
                }
                self.currentIndex += 1
                if self.currentIndex == self.users.count {
                    self.addEndMatchUserView()
                    print("Закончилось")
                } else {
                    self.tumblerForTransitionLeftorRight = false
                    self.showCurrentUserContinue(users: self.users)
                }
            }
        }
    }
}

extension MatchViewController: EndMatchProtocol {
    func returnUsers() {
        currentIndex = 0
        
//        print(users.count)
//        showOrAlpha(object: matchView, true, 0.4)
//        showOrAlpha(object: endMatchUserView, false, 0.4)
    }
}
