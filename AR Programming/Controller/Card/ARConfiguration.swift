//
//  ARConfiguration.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class ARConfiguration: NSObject, ARSessionDelegate, ARSCNViewDelegate {
    
    var sceneView: ARSCNView
    var configuration : ARWorldTrackingConfiguration
    var options : ARSession.RunOptions
    var cardWorld = CardWorld()
    
    private var cardDetector: CardDetector
    var cardDetectorDelegate : CardDetectorDelegate? {
        get {
            return cardDetector.delegate
        }
        set {
            cardDetector.delegate = newValue
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
    
    init(with scene: ARSCNView, for imageGroup: String) {
        sceneView = scene
        cardDetector = CardDetector(with: scene, with: cardWorld)
        
        configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: imageGroup, bundle: nil)
        configuration.maximumNumberOfTrackedImages = 6
        
        options = [.resetTracking, .removeExistingAnchors]
        
        super.init()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
    }
    
    public func start() {
        sceneView.session.run(configuration, options: options)
        cardWorld.reset()
    }
    
    public func stop() {
        cardDetector.stop()
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        cardDetector.session(session, didUpdate: anchors)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        cardDetector.renderer(renderer, didAdd: node, for: anchor)
    }
}
