//
//  CardLibraryViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class CardLibraryViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView! {
        didSet {
            cardCollectionView.delegate = flowLayoutDelegate
            cardCollectionView.dataSource = dataSource
            cardCollectionView.register(UINib(nibName: "CardCollectionViewHomeHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader")
            cardCollectionView.register(UINib(nibName: "CardCollectionViewSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        }
    }
    
    // Injected properties
    var flowLayoutDelegate: UICollectionViewDelegateFlowLayout?
    var dataSource: CardCollectionDataSource?
    var grade: Int! {
        didSet {
            dataSource?.setGrade(grade: grade)
        }
    }
    
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
        if segue.identifier == "CardDetailSegue" {
            if let detail = segue.destination as? CardDetailViewController,
                let cardCell = sender as? CardCollectionViewCell {
                
                if let card = cardCell.card {
                    detail.card = card
                    detail.cardPreview = cardCell.image.image
                }
            }
        }
    }
}
