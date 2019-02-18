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
    let cardWorld = CardWorld()
    
    var cardMapper: CardMapper? {
        didSet{
            sceneView.session.pause()
            sceneView.session.run(configuration, options: [options, ARSession.RunOptions.removeExistingAnchors])
        }
    }
    
    weak var cardScannerDelegate: CardScannerDelegate?
    weak var planeDetectorDelegate: PlaneDetectorDelegate?
    private var currentPlane: Plane?
    
    init(with scene: ARSCNView) {
        sceneView = scene
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        
        configuration = ARWorldTrackingConfiguration()
        configuration.maximumNumberOfTrackedImages = 6
        configuration.planeDetection = .horizontal
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: nil)
        
        options = [.resetTracking]
        
        super.init()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
    }
    
    func start() {
        cardWorld.reset()
        sceneView.session.run(configuration, options: options)
    }
    
    func stop() {
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        //This code has been disabled because if instability with ARKit - we did not have the time to resolve it
//        for anchor in anchors {
//            if let imageAnchor = anchor as? ARImageAnchor, let name = imageAnchor.referenceImage.name {
//                if !imageAnchor.isTracked {
//                    //Start timer to remove card
//                } else {
//                    //Stop timer for card, as it has been found again
//                }
//            }
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            handleCardDetected(imageAnchor: imageAnchor, node: node)
        } else if let planeAnchor = anchor as? ARPlaneAnchor {
            handlePlaneDetected(planeAnchor: planeAnchor, node: node)
        }
    }
    
    private func handleCardDetected(imageAnchor: ARImageAnchor, node: SCNNode) {
        //
    }
    
    private func handlePlaneDetected(planeAnchor: ARPlaneAnchor, node: SCNNode) {
        if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            let oldPlane = currentPlane
 
            var plane = Plane(anchor: planeAnchor)
            let ground = SCNNode(geometry: SCNPlane(width: 0.2, height: 0.2))
            ground.eulerAngles.x = -.pi / 2
            ground.geometry?.materials.first?.diffuse.contents = UIImage(named: "tron_grid")
            plane.groundNode = ground
            node.addChildNode(plane.root)
            
            currentPlane = plane
            planeDetectorDelegate?.planeDetector(self, found: plane)
            
            if let plane = oldPlane {
                sceneView.session.remove(anchor: plane.anchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let hitResults = sceneView.hitTest(CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2), options: [SCNHitTestOption.searchMode: 1])
        
        for result in hitResults {
            if let card = cardWorld.card(from: result.node) {
                cardScannerDelegate?.cardScanner(self, scanned: card)
                return
            }
        }
        
        if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            if let hit = frame.hitTest(CGPoint(x: 0.5, y: 0.5), types: [.existingPlane]).first {
                currentPlane?.root.position = SCNVector3(hit.localTransform.columns.3.x, hit.localTransform.columns.3.y, hit.localTransform.columns.3.z)
            }
        }
        
        cardScannerDelegate?.cardScannerLostCard(self)
    }
}
