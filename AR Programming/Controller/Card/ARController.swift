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
    private var currentPlaneAnchor: ARAnchor?
    
    weak var frameDelegate: FrameDelegate?
    weak var planeDetectorDelegate: PlaneDetectorDelegate?
    
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
            if let currentPlaneAnchor = currentPlaneAnchor {
                sceneView.session.remove(anchor: currentPlaneAnchor)
            }
            currentPlaneAnchor = planeAnchor
            
            handlePlaneDetected(planeAnchor: planeAnchor, node: node)
        }
    }
    
    private func handlePlaneDetected(planeAnchor: ARPlaneAnchor, node: SCNNode) {
        if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            if currentPlane == nil {
                currentPlane = createPlane()
                sceneView.scene.rootNode.addChildNode(currentPlane!.root)
                
                planeDetectorDelegate?.planeDetector(self, found: currentPlane!)
            }
        }
    }
    
    private func createPlane() -> Plane {
        var plane = Plane()
        
        let ground = SCNNode(geometry: SCNPlane(width: 0.2, height: 0.2))
        ground.eulerAngles.x = -.pi / 2
        ground.geometry?.materials.first?.diffuse.contents = UIImage(named: "tron_grid")
        plane.groundNode = ground
        
        return plane
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let orientation = CGImagePropertyOrientation(UIDevice.current.orientation)
        let image = frame.capturedImage
        frameDelegate?.frameScanner(self, didUpdate: image, withOrientation: orientation)
        
        if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            if let hit = frame.hitTest(CGPoint(x: 0.5, y: 0.5), types: [.existingPlane]).first {
                currentPlane?.root.position = SCNVector3(hit.worldTransform.translation)
            }
        }
    }
}
