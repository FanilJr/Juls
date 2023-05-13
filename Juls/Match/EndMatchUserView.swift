//
//  EndMatchUserView.swift
//  Juls
//
//  Created by Fanil_Jr on 06.05.2023.
//

import Foundation
import UIKit

protocol EndMatchProtocol: AnyObject {
    func returnUsers()
}
class EndMatchUserView: UIView {
    
    var user: User? {
        didSet {
            guard let name = user?.name else { return }
            self.matchLabel.text = "\(name), зайдите позднее... На сегодня вы всех посмотрели"
        }
    }
    
    weak var delegate: EndMatchProtocol?
    
    var loveImage: UIImageView = {
        var love = UIImageView()
        love.translatesAutoresizingMaskIntoConstraints = false
        love.contentMode = .scaleAspectFill
        love.image = UIImage(named: "heart-hands")
        return love
    }()
    
    var matchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.createColor(light: .systemPurple, dark: .systemPurple)
        label.shadowColor = UIColor.createColor(light: .black, dark: .black)
        label.font = UIFont(name: "Futura-Bold", size: 40)
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    var disslikeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.createColor(light: .systemPurple, dark: .systemPurple)
        label.shadowColor = UIColor.createColor(light: .black, dark: .black)
        label.font = UIFont(name: "Futura-Bold", size: 15)
        label.numberOfLines = 0
        label.text = "Посмотрите на тех кого вы дисслайкнули"
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    lazy var returnButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(returnUsers), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "left-arrow-curving-right"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        alpha = 0.0
        translatesAutoresizingMaskIntoConstraints = false
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func returnUsers() {
        print("return")
        delegate?.returnUsers()
    }
    
    func layout() {
        [loveImage,matchLabel,disslikeLabel,returnButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            loveImage.topAnchor.constraint(equalTo: topAnchor,constant: 40),
            loveImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            loveImage.heightAnchor.constraint(equalToConstant: 100),
            loveImage.widthAnchor.constraint(equalToConstant: 100),
            
            matchLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            matchLabel.topAnchor.constraint(equalTo: loveImage.bottomAnchor,constant: 30),
            matchLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            matchLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            disslikeLabel.topAnchor.constraint(equalTo: matchLabel.bottomAnchor,constant: 40),
            disslikeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            returnButton.topAnchor.constraint(equalTo: disslikeLabel.bottomAnchor,constant: 20),
            returnButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            returnButton.heightAnchor.constraint(equalToConstant: 50),
            returnButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
