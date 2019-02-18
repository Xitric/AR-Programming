//
//  ScanViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class ScanViewController : UIViewController, GameplayController, FrameDelegate, CardNodeDetectorDelegate {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    
    private var detector: BarcodeDetector!
    
    @IBAction func back(_ sender: UIButton) {
        if let parent = self.parent as? HiddenTabBarViewController {
            parent.goToViewControllerWith(index: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = CardNodeDetector(detectionArea: CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5))
        config.delegate = self
        detector = BarcodeDetector(config: config,
                                   screenWidth: Double(UIScreen.main.bounds.width),
                                   screenHeight: Double(UIScreen.main.bounds.height))
    }
    
    func enter(withLevel level: Level?, inEnvironment arController: ARController?) {
        arController?.frameDelegate = self
    }
    
    func exit(withLevel level: Level?, inEnvironment arController: ARController?) {
        arController?.frameDelegate = nil
    }
    
    func frameScanner(_ scanner: ARController, didUpdate frame: CVPixelBuffer, withOrientation orientation: CGImagePropertyOrientation) {
        detector.analyze(frame: frame, oriented: orientation)
    }
    
    func nodeDetector(_ detector: CardNodeDetector, found cardNodes: [CardNode]) {
        if cardNodes.count == 0 {
            display(card: nil)
        } else if cardNodes.count == 1 {
            display(card: cardNodes[0].getCard())
        } else {
            display(text: "For mange kort", description: "Der er for mange kort i feltet. Hvilket kort vil du vide mere om?")
        }
    }
    
    private func display(card optCard: Card?) {
        if let card = optCard {
            self.cardName.text = "\(card.name) | \(card.summary)"
            self.cardDescription.text = card.description
            self.cardImage.image = UIImage(named: card.internalName)
        } else {
            self.cardName.text = "Intet kort fundet"
            self.cardDescription.text = "Peg feltet i midten af skærmen mod et kort for at lære mere om det!"
            self.cardImage.image = nil
        }
    }
    
    private func display(text: String, description: String) {
        self.cardName.text = text
        self.cardDescription.text = description
        self.cardImage.image = nil
    }
}
