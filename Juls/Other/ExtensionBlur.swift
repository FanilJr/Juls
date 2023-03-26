//
//  extensionBlur.swift
//  Juls
//
//  Created by Fanil_Jr on 26.03.2023.
//

import Foundation
import UIKit

extension UIView {
    func blur(radius: CGFloat) {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds.insetBy(dx: -radius, dy: -radius)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
}
