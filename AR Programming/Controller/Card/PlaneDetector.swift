//
//  PlaneDetector.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class PlaneDetector {
    
    weak var delegate: PlaneDetectorDelegate?
    private var sceneView: ARSCNView
    var currentPlane: Plane?
    
    init(with scene: ARSCNView) {
        self.sceneView = scene
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if delegate?.shouldDetectPlanes(self) ?? false {
            guard anchor is ARPlaneAnchor else { return }
            
            if let plane = currentPlane {
                sceneView.session.remove(anchor: plane.anchor)
                plane.node.removeFromParentNode()
            }
            
            let plane = Plane(width: 0.2, height: 0.2, anchor: anchor)
            plane.node.geometry?.materials.first?.diffuse.contents = UIImage(named: "tron_grid")
            node.addChildNode(plane.node)
            
            currentPlane = plane
            delegate?.planeDetector(self, found: plane)
        }
    }
}
