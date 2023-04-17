//
//  ImageExtension.swift
//  Juls
//
//  Created by Fanil_Jr on 02.04.2023.
//

import Foundation
import UIKit

extension UIImage {
    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
