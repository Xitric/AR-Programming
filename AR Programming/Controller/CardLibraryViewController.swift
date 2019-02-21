//
//  CardLibraryViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CardLibraryViewController: UIViewController {

    private var cardFactory = CardNodeFactory.instance
    private lazy var cardLibrary = cardFactory.cards
    
    @IBOutlet weak var CardCollectionView: UICollectionView! {
        didSet {
            CardCollectionView.dataSource = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Card Information" {
            if let cdvc = segue.destination as? CardDetailViewController {
                let card = sender as! CardCollectionViewCell
                cdvc.cardTitle = card.cardTitle
                cdvc.cardDescription = card.cardDescription
                cdvc.cardImage = card.image.image
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CardLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardLibrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        if let cardCell = cell as? CardCollectionViewCell {
            let card = cardLibrary[indexPath.item]
            let cardLibraryImage = UIImage(named: card.internalName)
            cardCell.image.image = cardLibraryImage
            cardCell.cardTitle = card.name
            cardCell.cardDescription = card.description
        }
        return cell
    }
}
