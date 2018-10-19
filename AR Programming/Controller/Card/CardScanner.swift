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
    private var sceneView: ARSCNView
//    var cardMapper: CardMapper?
//    var levelDatabase: LevelDatabase?
   var cardWorld: CardWorld?
    
    init(with scene: ARSCNView, with cardWorld: CardWorld) {
        self.sceneView = scene
        self.cardWorld = cardWorld
//        levelDatabase = LevelDatabase()
//        cardMapper = levelDatabase?.levels[0]

    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let hitResults = sceneView.hitTest(CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2), options: nil)
        
        if let result = hitResults.first {
            let anchor = sceneView.anchor(for: result.node)
            
            if let imageAnchor = anchor as? ARImageAnchor, let number = Int(imageAnchor.referenceImage.name!) {
                let card = cardWorld?.cardFromNode(node: result.node)
                delegate?.cardScanner(self, scanned: card!)
//                let card = cardMapper?.getCard(i: number)
//                delegate?.cardScanner(self, scanned: card!)
                return
            }
        }
        
        delegate?.cardScannerLostCard(self)
    }
}
