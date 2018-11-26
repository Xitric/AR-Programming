//
//  CardLibraryViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //private var cardLibrary = [#imageLiteral(resourceName: "Start"),#imageLiteral(resourceName: "Left"),#imageLiteral(resourceName: "Right"),#imageLiteral(resourceName: "Move"),#imageLiteral(resourceName: "Jump"),#imageLiteral(resourceName: "Branch")]

    private var cardFactory = CardFactory.instance
    private lazy var cardLibrary = cardFactory.cardLibrary
    
    @IBOutlet weak var CardCollectionView: UICollectionView! {
        didSet {
            CardCollectionView.dataSource = self
            CardCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardLibrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        if let cardCell = cell as? CardCollectionViewCell {
            let card = cardLibrary[indexPath.item]
            let cardLibraryImage = UIImage(named: card.name)
            cardCell.image.image = cardLibraryImage
            cardCell.cardTitle = card.name
            cardCell.cardDescription = card.description
        }
        return cell
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
