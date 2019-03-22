//
//  CardDescriptionViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit


/// A controller for displaying helpful information about a specific card.
class CardDescriptionViewController: UIViewController {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    
    /// Property for injecting which card must be displayed in the view of this controller.
    var card: Card? {
        didSet {
            if let card = card {
                self.cardName.text = "\(card.name) | \(card.summary)"
                self.cardDescription.text = card.description
                self.cardImage.image = UIImage(named: card.internalName)
            } else {
                returnToLevelView()
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        returnToLevelView()
    }
    
    private func returnToLevelView() {
        if let parent = self.parent as? GameViewCoordinationController {
            parent.goToLevelView()
        }
    }
}
