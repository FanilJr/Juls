//
//  HomeEmptyStateView.swift
//  Juls
//
//  Created by Fanil_Jr on 08.03.2023.
//

import Foundation
import UIKit

class HomeEmptyStateView: UIView {
    
    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "Welcome to ~Juls~\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSMutableAttributedString(string: "When you follow people, you'll see the photos and videos they share here.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = attributedText
        return label
    }()
    
    static var cellId = "homeEmptyStateCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(noPostsLabel)
        
        NSLayoutConstraint.activate([
            noPostsLabel.topAnchor.constraint(equalTo: topAnchor),
            noPostsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noPostsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            noPostsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
