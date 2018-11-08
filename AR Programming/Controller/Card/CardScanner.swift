//
//  CardScanner.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class CardScanner: NSObject, ARSessionDelegate {
    
    weak var delegate : CardScannerDelegate?
    var cardWorld: CardWorld
    private var sceneView: ARSCNView
    
    init(with scene: ARSCNView, with cardWorld: CardWorld) {
        self.sceneView = scene
        self.cardWorld = cardWorld
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let hitResults = sceneView.hitTest(CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2), options: nil)
        
        for result in hitResults {
            if let card = cardWorld.card(from: result.node) {
                delegate?.cardScanner(self, scanned: card)
                return
            }
        }
        
        delegate?.cardScannerLostCard(self)
    }
}