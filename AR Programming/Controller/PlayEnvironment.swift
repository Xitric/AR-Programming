//
//  PlayEnvironment.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class PlayEnvironment: AREnvironment {
    
    public func start() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: nil)
        configuration.maximumNumberOfTrackedImages = 6
        // Detect horizontal planes
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        
    }
    
    public func stop() {
        sceneView.session.pause()
    }
}
