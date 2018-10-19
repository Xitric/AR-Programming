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
    
    init(with scene: ARSCNView) {
        self.sceneView = scene
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let hitResults = sceneView.hitTest(CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2), options: nil)
        
        if let result = hitResults.first {
            let anchor = sceneView.anchor(for: result.node)
            
            if let imageAnchor = anchor as? ARImageAnchor, let name = imageAnchor.referenceImage.name {
                delegate?.cardScanner(self, scanned: name)
                return
            }
        }
        
        delegate?.cardScannerLostCard(self)
    }
}
