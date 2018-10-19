//
//  ScanViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 16/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import ARKit

class ScanViewController: UIViewController, CardDetectorDelegate {
    
    @IBOutlet var sceneView: ARSCNView! {
        didSet {
            cardScanner = CardDetector(with: sceneView)
            environment = CardScannerEnvironment(sceneView: sceneView)
            environment!.add(scnDelegate: cardScanner!)
            environment!.add(sessDelegate: cardScanner!)
        }
    }
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    private var environment : CardScannerEnvironment?
    private var cardScanner : CardDetector? {
        didSet {
            cardScanner?.delegate = self
        }
    }
    private var cardDatabase = CardDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let scanner = cardScanner {
            scanner.start()
            environment!.start(withImages: "Cards")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let scanner = cardScanner {
            scanner.stop()
            environment!.stop()
        }
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
    
    func cardDetector(_ detector: CardDetector, added cardName: String) {
        
    }
    
    func cardDetector(_ detector: CardDetector, removed cardName: String) {
        
    }
    
    func cardDetector(_ detector: CardDetector, scanned cardName: String) {
        DispatchQueue.main.async {
            self.displayCard(withName: cardName)
        }
    }
    
    func cardDetectorLostCard(_ detector: CardDetector) {
        DispatchQueue.main.async {
            self.displayCard(withName: nil)
        }
    }
}
