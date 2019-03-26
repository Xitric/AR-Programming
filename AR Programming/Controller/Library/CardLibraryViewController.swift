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
    
    @IBOutlet weak var cardCollectionView: UICollectionView! {
        didSet {
            cardCollectionView.dataSource = dataSource
            cardCollectionView.delegate = flowLayoutDelegate
            cardCollectionView.register(UINib(nibName: "CardCollectionViewHomeHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader")
            cardCollectionView.register(UINib(nibName: "CardCollectionViewSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        }
    }
    
    private lazy var dataSource: CardCollectionDataSource = {
        let source = CardCollectionDataSource()
        return source
    }()
    private lazy var flowLayoutDelegate: CardCollectionFlowLayoutDelegate = {
       return CardCollectionFlowLayoutDelegate()
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cardCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let layout = cardCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
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
