//
//  RatingView.swift
//  Juls
//
//  Created by Fanil_Jr on 23.04.2023.
//

import Foundation
import UIKit

class RatingView: UIView {
    
    lazy var rating: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.createColor(light: .black, dark: .white)
        label.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura-Bold", size: 40)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.0
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        [rating].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            rating.centerXAnchor.constraint(equalTo: centerXAnchor),
            rating.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
