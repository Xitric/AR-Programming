//
//  PlayConfiguration.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class PlayConfiguration: ARConfiguration, ARSCNViewDelegate {

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
    
    override init(with scene: ARSCNView) {
        cardDetector = CardDetector(with: scene)
        planeDetector = PlaneDetector(with: scene)
        super.init(with: scene)
        
        self.sceneView.delegate = self
        
        configuration = ARWorldTrackingConfiguration()
        configuration!.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: nil)
        configuration!.maximumNumberOfTrackedImages = 6
        // Detect horizontal planes
        configuration!.planeDetection = .horizontal
        
        options = [.resetTracking, .removeExistingAnchors]
    }
}
