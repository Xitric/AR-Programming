//
//  ScanConfiguration.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class ScanConfiguration: ARConfiguration {
    
    private var cardScanner: CardScanner?
    
    var cardScannerDelegate : CardScannerDelegate? {
        get {
            return cardScanner?.delegate
        }
        set {
            cardScanner?.delegate = newValue
        }
    }
    
    override init(with scene: ARSCNView, for imageGroup: String) {
        super.init(with: scene, for: imageGroup)
        cardScanner = CardScanner(with: scene,  with: cardWorld)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        cardScanner?.session(session, didUpdate: frame)
    }
}
