//
//  CustomCollectionViewLayout.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 08.11.2023.
//

import UIKit

final class CustomCollectionViewLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        minimumLineSpacing = 15

        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        let attributes = originalAttributes.map { (attribute) -> UICollectionViewLayoutAttributes in
            if attribute.frame.maxY > maxY {
                leftMargin = sectionInset.left
                maxY = attribute.frame.maxY
            }
            attribute.frame.origin.x = leftMargin
            leftMargin += attribute.frame.width + minimumLineSpacing
            return attribute
        }
        return attributes

    }
}
