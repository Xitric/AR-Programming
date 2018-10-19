//
//  ScanConfiguration.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class ScanConfiguration: ARConfiguration, ARSessionDelegate, ARSCNViewDelegate {
    
    private var cardDetector: CardDetector
    private var cardScanner: CardScanner
    
    var cardDetectorDelegate : CardDetectorDelegate? {
        get {
            return cardDetector.delegate
        }
        set {
            cardDetector.delegate = newValue
        }
    }
    
    var cardScannerDelegate : CardScannerDelegate? {
        get {
            return cardScanner.delegate
        }
        set {
            cardScanner.delegate = newValue
        }
    }
    
    var cardMapper : CardMapper? {
        get {
            return cardDetector.cardMapper
        }
        set {
            cardDetector.cardMapper = newValue
        }
    }
    
    init(with scene: ARSCNView, for imageGroup: String, with cardWorld: CardWorld) {
        cardDetector = CardDetector(with: scene, with: cardWorld)
        cardScanner = CardScanner(with: scene,  with: cardWorld)
        super.init(with: scene, with: cardWorld)
        
        self.sceneView.delegate = self
        self.sceneView.session.delegate = self
        
        configuration = ARWorldTrackingConfiguration()
        configuration!.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: imageGroup, bundle: nil)
        configuration!.maximumNumberOfTrackedImages = 6
        
        options = [.resetTracking, .removeExistingAnchors]
    }
    
    override public func stop() {
        cardDetector.stop()
        super.stop()
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        cardDetector.session(session, didUpdate: anchors)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        cardDetector.renderer(renderer, didAdd: node, for: anchor)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        cardScanner.session(session, didUpdate: frame)
    }
}
