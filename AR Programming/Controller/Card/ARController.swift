//
//  ARController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class ARController: NSObject, ARSessionDelegate, ARSCNViewDelegate  {
    
    private let sceneView: ARSCNView
    private var configuration : ARWorldTrackingConfiguration
    private var options : ARSession.RunOptions
    private var currentPlane: Plane?
    
    weak var cardScannerDelegate: CardScannerDelegate?
    weak var planeDetectorDelegate: PlaneDetectorDelegate?
    weak var editor: ProgramEditor?
    
    init(with scene: ARSCNView) {
        sceneView = scene
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        
        configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        options = [.resetTracking]
        
        super.init()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
    }
    
    func start() {
        sceneView.session.run(configuration, options: options)
    }
    
    func stop() {
        sceneView.session.pause()
    }
    
    func restart() {
        stop()
        sceneView.session.run(configuration, options: [options, ARSession.RunOptions.removeExistingAnchors])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            handlePlaneDetected(planeAnchor: planeAnchor, node: node)
        }
    }
    
    private func handlePlaneDetected(planeAnchor: ARPlaneAnchor, node: SCNNode) {
        if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            let oldPlane = currentPlane
 
            let plane = Plane(width: 0.2, height: 0.2, anchor: planeAnchor)
            plane.node.geometry?.materials.first?.diffuse.contents = UIImage(named: "tron_grid")
            node.addChildNode(plane.node)
            
            currentPlane = plane
            planeDetectorDelegate?.planeDetector(self, found: plane)
            
            if let plane = oldPlane {
                sceneView.session.remove(anchor: plane.anchor)
                plane.node.removeFromParentNode()
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let orientation = CGImagePropertyOrientation(UIDevice.current.orientation)
        let image = frame.capturedImage
        editor?.newFrame(image, oriented: orientation)
    }
}
