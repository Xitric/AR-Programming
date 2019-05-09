//
//  CardCollectionFlowLayoutDelegate.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardCollectionFlowLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {

    private let approximateHomeHeaderHeight: CGFloat = 181
    private let approximateSectionHeaderHeight: CGFloat = 72
    private let preferredWidthFraction: CGFloat = 0.24
    private let minimumPreferredSize: CGFloat = 200

    // MARK: - Sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
            header.setNeedsLayout()
            header.layoutIfNeeded()

            let height = header.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
            return CGSize(width: collectionView.bounds.width, height: height)
        }

        // The method is run once before the headers are instantiated. This should prevent the constraints in the headers from not being satisfied
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: approximateHomeHeaderHeight)
        } else {
            return CGSize(width: collectionView.bounds.width, height: approximateSectionHeaderHeight)
        }
    }

    // MARK: - Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let parentBounds = collectionView.bounds
        var targetWidth = parentBounds.width * preferredWidthFraction

        if targetWidth < minimumPreferredSize {
            targetWidth = min(parentBounds.width, minimumPreferredSize)
        }

        return CGSize(width: targetWidth, height: targetWidth)
    }
}
