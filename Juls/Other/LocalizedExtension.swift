//
//  LocalizedExtension.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
