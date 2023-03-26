//
//  ActivityFunc.swift
//  Juls
//
//  Created by Fanil_Jr on 26.03.2023.
//

import Foundation
import UIKit

public func waitingSpinnerEnable(activity: UIActivityIndicatorView, active: Bool) {
    if active {
        activity.startAnimating()
    } else {
        activity.stopAnimating()
    }
}

public func showOrAlpha(object: UIView, _ show: Bool) {
    UIView.animate(withDuration: 0.1) {
        object.alpha = show ? 1.0 : 0.0
    }
}
