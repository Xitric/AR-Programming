//
//  CardCollectionFlowLayoutDelegate.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CardCollectionFlowLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    private let preferredWidthFraction: CGFloat = 0.24
    private let minimumPreferredSize: CGFloat = 200
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let parentBounds = collectionView.bounds
        var targetWidth = parentBounds.width * preferredWidthFraction
        
        if targetWidth < minimumPreferredSize {
            targetWidth = min(parentBounds.width, minimumPreferredSize)
        }
        
        return CGSize(width: targetWidth, height: targetWidth)
    }
}
