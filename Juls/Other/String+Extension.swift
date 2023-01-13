//
//  String+Extension.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

extension String {
    var encodeURL: String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl: String
    {
    return self.removingPercentEncoding!
    }
}
