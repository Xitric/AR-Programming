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
            arScanner = ScanConfiguration(with: sceneView, for: "Cards")
            arScanner?.cardScannerDelegate = self
            
            //TODO: Temporary
//            arScanner?.cardMapper = Level(cards:[
//                    1: Card(name: "Start", description: "Use the Start card to indicate where the program starts. Whenever the program is executed, it will begin at this card.", type: CardType.control, command: nil),
//                    2: Card(name: "Jump", description: "Use the Jump card to make the robot jump in place.", type: CardType.action, command: JumpCommand())])
        }
    }
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    private var arScanner : ScanConfiguration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arScanner?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arScanner?.stop()
    }
    
    private func display(card optCard: Card?) {
        if let card = optCard {
            self.cardNameLabel.text = card.name + " | " + card.type.rawValue + " Card"
            self.cardDescriptionLabel.text = card.description
            self.cardImage.image = UIImage(named: card.name + "Card")
        } else {
            self.cardNameLabel.text = "No card"
            self.cardDescriptionLabel.text = "Point the circle in the center of the screen at a card to learn more about it!"
            self.cardImage.image = nil
        }
    }
    
    func cardScanner(_ scanner: CardScanner, scanned card: Card) {
        DispatchQueue.main.async {
            self.display(card: card)
        }
    }
    
    func cardScannerLostCard(_ scanner: CardScanner) {
        DispatchQueue.main.async {
            self.display(card: nil)
        }
    }
}
