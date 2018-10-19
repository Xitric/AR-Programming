//
//  ScanViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 16/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import ARKit

class ScanViewController: UIViewController, CardScannerDelegate {
    
    @IBOutlet var sceneView: ARSCNView! {
        didSet {
            environment = ScanConfiguration(with: sceneView, for: "Cards")
            environment?.cardScannerDelegate = self
        }
    }
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    private var environment : ScanConfiguration?
    private var cardDatabase = CardDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        environment?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        environment?.stop()
    }
    
    private func displayCard(withName optName: String?) {
        if let card = cardDatabase.cards[optName ?? ""] {
            self.cardNameLabel.text = card.name + " | " + card.type.rawValue + " Card"
            self.cardDescriptionLabel.text = card.description
            self.cardImage.image = UIImage(named: optName! + "Card")
        } else {
            self.cardNameLabel.text = "No card"
            self.cardDescriptionLabel.text = "Point the circle in the center of the screen at a card to learn more about it!"
            self.cardImage.image = nil
        }
    }
    
    func cardScanner(_ scanner: CardScanner, scanned cardName: String) {
        DispatchQueue.main.async {
            self.displayCard(withName: cardName)
        }
    }
    
    func cardScannerLostCard(_ scanner: CardScanner) {
        DispatchQueue.main.async {
            self.displayCard(withName: nil)
        }
    }
}
