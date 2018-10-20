//
//  PlayConfiguration.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class PlayConfiguration: ARConfiguration {

    private var planeDetector: PlaneDetector
    var planeDetectorDelegate : PlaneDetectorDelegate? {
        get {
            return planeDetector.delegate
        }
        set {
            planeDetector.delegate = newValue
        }
    }
    
    override init(with scene: ARSCNView, for imageGroup: String) {
        planeDetector = PlaneDetector(with: scene)
        super.init(with: scene, for: imageGroup)
        
        configuration.planeDetection = .horizontal
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        planeDetector.renderer(renderer, didAdd: node, for: anchor)
        super.renderer(renderer, didAdd: node, for: anchor)
    }
}
