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
    private var removeTimers = [String:Timer]()
    private var sceneView: ARSCNView
    
    init(with scene: ARSCNView) {
        self.sceneView = scene
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
            removeTimers[name] = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.remove(_:)), userInfo: anchor, repeats: false)
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
            if let name = anchor.referenceImage.name {
                delegate?.cardDetector(self, lost: name)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor, let name = imageAnchor.referenceImage.name {
                if !imageAnchor.isTracked {
                    //TODO: Temporarily disabled anchor removal due to ARKit instability
                    //                    startTimer(for: imageAnchor, with: name)
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
        
        node.addChildNode(plane.planeNode)
        
        if let name = referenceImage.name {
            delegate?.cardDetector(self, found: name)
        }
    }
}
