//
//  CardScannerEnvironment.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class CardScannerEnvironment: AREnvironment {
    
    private var configuration : ARWorldTrackingConfiguration?
    private var options : ARSession.RunOptions?
    
    private func configureAR(withImages imageGroup: String) {
        configuration = ARWorldTrackingConfiguration()
        configuration!.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: imageGroup, bundle: nil)
        configuration!.maximumNumberOfTrackedImages = 6
        
        options = [.resetTracking, .removeExistingAnchors]
    }
    
    public func start(withImages imageGroup: String) {
        self.configureAR(withImages: imageGroup)
        
        if let conf = configuration, let opt = options {
            sceneView.session.run(conf, options: opt)
        }
    }
    
    public func stop() {
        sceneView.session.pause()
    }
}
