//
//  CustomButton.swift
//  Juls
//
//  Created by Fanil_Jr on 13.05.2023.
//

import Foundation
import UIKit

final class CustomButton: UIButton {
    private var title: String
    private var titleColor: UIColor
    private var image: UIImage
    private var onTap: (() -> Void)?
    
    init(title: String, titleColor: UIColor, image: UIImage, onTap: (() -> Void)?) {
        self.title = title
        self.titleColor = titleColor
        self.onTap = onTap
        self.image = image
        
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setBackgroundImage(image, for: .normal)
        addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
    }
    
    deinit {
        print("deinit button")
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleButtonTapped() {
        onTap?()
    }
}
