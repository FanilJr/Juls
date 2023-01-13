//
//  Photos.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

public var galery: [UIImage]  {

        var galeryPhoto = [UIImage]()
        
        for i in 1...19 {
            galeryPhoto.append(UIImage(named: "P\(i)")!)
        }
        return galeryPhoto
}
