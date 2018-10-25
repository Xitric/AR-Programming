//
//  CardDetector.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class CardDetector: NSObject, ARSessionDelegate, ARSCNViewDelegate {
    
    weak var delegate : CardDetectorDelegate?
    var cardMapper: CardMapper?
    private var cardWorld: CardWorld
    private var removeTimers = [String:Timer]()
    private var sceneView: ARSCNView
    
    init(with scene: ARSCNView, with cardWorld: CardWorld) {
        self.sceneView = scene
        self.cardWorld = cardWorld
    }
    
    public func stop() {
        stopAllTimers()
    }
    
    private func stopAllTimers() {
        for (_, removeTimer) in removeTimers {
            removeTimer.invalidate()
        }
        
        removeTimers.removeAll()
    }
    
    private func startTimer(for anchor: ARImageAnchor, with name: String) {
        if removeTimers[name] == nil {
            removeTimers[name] = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.remove(_:)), userInfo: anchor, repeats: false)
        }
    }
    
    private func stopTimer(for cardName: String) {
        if let removeTimer = removeTimers[cardName] {
            removeTimer.invalidate()
            removeTimers.removeValue(forKey: cardName)
        }
    }
    
    @objc public func remove(_ timer: Timer) {
        if let anchor = timer.userInfo as? ARImageAnchor {
            sceneView.session.remove(anchor: anchor)
            
            if let node = sceneView.node(for: anchor), let plane = cardWorld.plane(from: node) {
                let card = cardWorld.card(from: plane)
                cardWorld.removeCard(plane: plane)
                delegate?.cardDetector(self, lost: card!)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor, let name = imageAnchor.referenceImage.name {
                if !imageAnchor.isTracked {
                    startTimer(for: imageAnchor, with: name)
                } else {
                    stopTimer(for: name)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        let referenceImage = imageAnchor.referenceImage
        let plane = Plane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height, anchor: anchor)
        
        node.addChildNode(plane.node)
        
        if let cardIdentifier = Int(referenceImage.name!) {
            if let card = cardMapper?.getCard(identifier: cardIdentifier) {
                cardWorld.addCard(plane: plane, card: card)
                delegate?.cardDetector(self, found: card)
            }
        }
    }
}
