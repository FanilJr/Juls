//
//  ColorMode.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

public extension UIColor {
    static func createColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { ( traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? dark : light }
    }
}
