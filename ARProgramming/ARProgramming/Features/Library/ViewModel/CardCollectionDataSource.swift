//
//  CardCollectionDataSource.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class CardCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    private let viewModel: CardCollectionViewModel
    
    init(viewModel: CardCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    func setGrade(grade: Int) {
        viewModel.setGrade(grade: grade)
    }
    
    //MARK: - Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfTypes
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerIdentifier = indexPath.section == 0 ? "HomeHeader" : "SectionHeader"
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
        
        if let header = header as? CardCollectionViewSectionHeader {
            let sectionType = viewModel.cardTypes[indexPath.section]
            header.text = viewModel.displayName(ofType: sectionType)
        }
        
        return header
    }
    
    //MARK: - Cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.cardTypes[section]
        return viewModel.numberOfCards(ofType: sectionType)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        
        if let cell = cell as? CardCollectionViewCell {
            let sectionType = viewModel.cardTypes[indexPath.section]
            let card = viewModel.cards(ofType: sectionType)[indexPath.item]
            let cardImage = UIImage(named: card.internalName)
            
            cell.image.image = cardImage
            cell.card = card
        }
        
        return cell
    }
}

