//
//  CollectionViewFlowLayout.swift
//  Juls
//
//  Created by Fanil_Jr on 27.01.2023.
//

import Foundation
import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
