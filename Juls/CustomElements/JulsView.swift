//
//  JulsView.swift
//  Juls
//
//  Created by Fanil_Jr on 12.01.2023.
//

import Foundation
import UIKit

class JulsView: UIView {
    
    var julsImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Juls")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        layoutView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        addSubview(julsImageView)
        
        NSLayoutConstraint.activate([
            julsImageView.topAnchor.constraint(equalTo: topAnchor),
            julsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            julsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            julsImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
