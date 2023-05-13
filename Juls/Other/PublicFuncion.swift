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

public func showOrAlpha(object: UIView, _ show: Bool, _ duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
        object.alpha = show ? 1.0 : 0.0
    }
}

public func showAnimate(mainObject: UIViewController,firstObject: UIView, objectSecond: UIView, alphaFirst: UIView, alphaSecond: UIView, alphaThree: UIView, alphaFour: UIView,animate: Bool) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0) {
        firstObject.transform = animate ? CGAffineTransform(translationX: mainObject.view.center.x + firstObject.bounds.width / 2, y: 0) : CGAffineTransform(translationX: 0, y: 0)
        objectSecond.transform = animate ? CGAffineTransform(translationX: -mainObject.view.center.x - objectSecond.bounds.width / 2, y: 0) : CGAffineTransform(translationX: 0, y: 0)
        alphaFirst.alpha = animate ? 1.0 : 0.0
        alphaSecond.alpha = animate ? 1.0 : 0.0
        alphaThree.alpha = animate ? 1.0 : 0.0
        alphaFour.alpha = animate ? 1.0 : 0.0
    }
}

public func animateElementRating(object: UIView, animate: Bool, duration: TimeInterval, delay: TimeInterval, yTransform: CGFloat, xTransform: CGFloat) {
    UIView.animate(withDuration: duration, delay: delay) {
        object.transform = animate ? CGAffineTransform(translationX: xTransform, y: yTransform) : CGAffineTransform(translationX: 0, y: 0)
        object.alpha = animate ? 1.0 : 0.0
    }
}
