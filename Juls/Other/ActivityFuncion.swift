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
