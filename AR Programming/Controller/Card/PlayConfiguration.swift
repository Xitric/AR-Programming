//
//  PlayConfiguration.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class PlayConfiguration: ARConfiguration, ARSessionDelegate, ARSCNViewDelegate {

    private var cardDetector: CardDetector
    private var planeDetector: PlaneDetector
    
    var cardDetectorDelegate : CardDetectorDelegate? {
        get {
            return cardDetector.delegate
        }
        set {
            cardDetector.delegate = newValue
        }
    }
    
    var planeDetectorDelegate : PlaneDetectorDelegate? {
        get {
            return planeDetector.delegate
        }
        set {
            planeDetector.delegate = newValue
        }
    }
    
    override init(with scene: ARSCNView, with cards: CardWorld) {
        cardDetector = CardDetector(with: scene, with: cards )
        planeDetector = PlaneDetector(with: scene)
        super.init(with: scene, with: cards)
        
        self.sceneView.delegate = self
        self.sceneView.session.delegate = self
        
        configuration = ARWorldTrackingConfiguration()
        configuration!.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: nil)
        configuration!.maximumNumberOfTrackedImages = 6
        // Detect horizontal planes
        configuration!.planeDetection = .horizontal
        
        options = [.resetTracking, .removeExistingAnchors]
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        cardDetector.session(session, didUpdate: anchors)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        planeDetector.renderer(renderer, didAdd: node, for: anchor)
        cardDetector.renderer(renderer, didAdd: node, for: anchor)
    }
}
