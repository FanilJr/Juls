//
//  SaveView.swift
//  Juls
//
//  Created by Fanil_Jr on 07.01.2023.
//

import Foundation
import UIKit

class SaveView: UIView {
    
    let save: UIImageView = {
        let like = UIImageView()
        like.image = UIImage(systemName: "checkmark.circle.fill")
        like.translatesAutoresizingMaskIntoConstraints = false
        like.contentMode = .scaleAspectFit
        like.tintColor = .systemBlue
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
        [save].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            save.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            save.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            save.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            save.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
        ])
    }
}


