//
//  GameViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 23.03.2023.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    private let waitLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "В разработке..."
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 25)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 0.0
        i.clipsToBounds = true
        return i
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Game"
        layout()
    }
    
    func animate() {
        UIView.animate(withDuration: 1) {
            self.waitLabel.alpha = 1
            self.waitLabel.transform = CGAffineTransform(translationX: 0, y: -100)
        }
    }
    
    func layout() {
        view.addSubview(waitLabel)
        
        NSLayoutConstraint.activate([
            waitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waitLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 100)
        ])
        
        self.animate()
    }
}
