//
//  LikeView.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

class LikeView: UIView {
    
    let like: UIImageView = {
        let like = UIImageView()
        like.image = UIImage(systemName: "heart.fill")
        like.translatesAutoresizingMaskIntoConstraints = false
        like.contentMode = .scaleAspectFit
        like.tintColor = .systemGray5
        return like
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        let blureEffect = UIBlurEffect(style: .light)
        let bluerView = UIVisualEffectView(effect: blureEffect)
        bluerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bluerView.frame = self.bounds
        bluerView.layer.cornerRadius = 30
        bluerView.clipsToBounds = true
        insertSubview(bluerView, at: 0)
        layoutView()
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 30
        self.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        addSubview(like)
        NSLayoutConstraint.activate([
            like.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            like.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            like.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            like.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10)
        ])
    }
}

