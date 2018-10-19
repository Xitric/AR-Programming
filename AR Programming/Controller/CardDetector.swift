//
//  CardScanner.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit
import UIKit

class CardDetector: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    
    private var sceneView : ARSCNView
    private var removeTimers = [String:Timer]()
    public var cardPlanes = [Plane]()
    weak var delegate: CardDetectorDelegate?
    
    init(with sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
    }
    
    public func start() {
        
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
                delegate?.cardDetector(self, removed: name)
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
        cardPlanes.append(plane)

        node.addChildNode(plane.planeNode)

        if let name = referenceImage.name {
            delegate?.cardDetector(self, added: name)
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let hitResults = sceneView.hitTest(CGPoint(x: sceneView.frame.width / 2, y: sceneView.frame.height / 2), options: nil)
        
        if let result = hitResults.first {
            let anchor = sceneView.anchor(for: result.node)
            
            if let imageAnchor = anchor as? ARImageAnchor, let name = imageAnchor.referenceImage.name {
                delegate?.cardDetector(self, scanned: name)
                return
            }
        }
        
        delegate?.cardDetectorLostCard(self)
    }
}
