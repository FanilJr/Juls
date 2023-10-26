//
//  GameViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 23.03.2023.
//

import Foundation
import UIKit
import Firebase

class GameViewController: UIViewController {
    
    var user: User?
    var gameStartView = GameStartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    func setupDidLoad() {
        view.backgroundColor = .systemGray6
        title = "Game"
        layout()
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: uid) { user in
            DispatchQueue.main.async {
                self.user = user
                self.gameStartView.user = user
                self.gameStartView.imageUser.loadImage(urlString: user.picture)
                self.gameStartView.startAnimate()
            }
        }
    }
    
    func layout() {
        [gameStartView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            gameStartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameStartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameStartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameStartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        gameStartView.delegate = self
        fetchUser()
    }
}

extension GameViewController: GameStartProtocol {
    func start() {
        print("start Game")
    }
}
