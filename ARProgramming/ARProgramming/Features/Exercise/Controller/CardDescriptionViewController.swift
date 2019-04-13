//
//  CardDescriptionViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

/// A controller for displaying helpful information about a specific card.
class CardDescriptionViewController: UIViewController {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    
    /// Property for injecting which card must be displayed in the view of this controller.
    var card: Card? {
        didSet {
            if let card = card {
                let name = NSLocalizedString("\(card.internalName).name", comment: "")
                let summary = NSLocalizedString("\(card.internalName).summary", comment: "")
                let description = NSLocalizedString("\(card.internalName).description", comment: "")
                
                self.cardName.text = "\(name) | \(summary)"
                self.cardDescription.text = description
                self.cardImage.image = UIImage(named: card.internalName)
            } else {
                delegate?.auxiliaryViewCompleted(self)
            }
        }
    }
    weak var delegate: AuxiliaryExerciseViewDelegate?
    
    @IBAction func back(_ sender: UIButton) {
        delegate?.auxiliaryViewCompleted(self)
    }
}
