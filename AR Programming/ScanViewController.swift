//
//  ScanViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class ScanViewController : UIViewController, CardScannerDelegate {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    
    func cardScanner(_ scanner: ARController, scanned card: Card) {
        //TODO: Should we use unowned self?
        DispatchQueue.main.async {
            self.display(card: card)
        }
    }
    
    func cardScannerLostCard(_ scanner: ARController) {
        //TODO: Should we use unowned self?
        DispatchQueue.main.async {
            self.display(card: nil)
        }
    }
    
    private func display(card optCard: Card?) {
        if let card = optCard {
            self.cardName.text = card.name + " | " + card.type.rawValue + " Card"
            self.cardDescription.text = card.description
            self.cardImage.image = UIImage(named: card.name + "Card")
        } else {
            self.cardName.text = "No card"
            self.cardDescription.text = "Point the circle in the center of the screen at a card to learn more about it!"
            self.cardImage.image = nil
        }
    }
}
