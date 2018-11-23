//
//  ARController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class ARController: NSObject, ARSessionDelegate, ARSCNViewDelegate  {
    
    private let sceneView: ARSCNView
    private var configuration : ARWorldTrackingConfiguration
    private var options : ARSession.RunOptions
    let cardWorld = CardWorld()
    
    var cardMapper: CardMapper?
    
    weak var cardScannerDelegate: CardScannerDelegate?
    weak var planeDetectorDelegate: PlaneDetectorDelegate?
    private var currentPlane: Plane?
    
    init(with scene: ARSCNView) {
        sceneView = scene
        
        configuration = ARWorldTrackingConfiguration()
        configuration.maximumNumberOfTrackedImages = 6
        configuration.planeDetection = .horizontal
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: nil)
        
        options = [.resetTracking, .removeExistingAnchors]
        
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
//        for anchor in anchors {
//            if let imageAnchor = anchor as? ARImageAnchor, let name = imageAnchor.referenceImage.name {
//                if !imageAnchor.isTracked {
//                    //TODO: Start timer to remove card
//                } else {
//                    //TODO: Stop timer for card, as it has been found again
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
        let referenceImage = imageAnchor.referenceImage
        let plane = Plane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height, anchor: imageAnchor)
        
        if let cardIdentifier = Int(referenceImage.name!) {
            if let card = cardMapper?.getCard(identifier: cardIdentifier) {
                plane.node.geometry?.firstMaterial?.diffuse.contents = "Card Library/\(card.name).png"
                node.addChildNode(plane.node)
                
                cardWorld.addCard(plane: plane, card: card)
            }
        }
    }
    
    private func handlePlaneDetected(planeAnchor: ARPlaneAnchor, node: SCNNode) {
        if planeDetectorDelegate?.shouldDetectPlanes(self) ?? false {
            if let plane = currentPlane {
                sceneView.session.remove(anchor: plane.anchor)
                plane.node.removeFromParentNode()
            }
            
            let plane = Plane(width: 0.2, height: 0.2, anchor: planeAnchor)
            plane.node.geometry?.materials.first?.diffuse.contents = UIImage(named: "tron_grid")
            node.addChildNode(plane.node)
            
            currentPlane = plane
            planeDetectorDelegate?.planeDetector(self, found: plane)
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
        
        cardScannerDelegate?.cardScannerLostCard(self)
    }
}
