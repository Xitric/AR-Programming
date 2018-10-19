//
//  AREnvironment.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

//Very bad, we would love to do it better :)
class AREnvironment: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    
    private var sceneViewDelegates = [ARSCNViewDelegate]()
    private var sessionDelegates = [ARSessionDelegate]()
    internal var sceneView: ARSCNView
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
        
        self.sceneView.delegate = self
        self.sceneView.session.delegate = self
    }
    
    //TODO: Weak references to avoid cycles
    public func add(scnDelegate: ARSCNViewDelegate) {
        sceneViewDelegates.append(scnDelegate)
    }
    
    public func add(sessDelegate: ARSessionDelegate) {
        sessionDelegates.append(sessDelegate)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for delegate in sessionDelegates {
            delegate.session?(session, didUpdate: anchors)
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        for delegate in sessionDelegates {
            delegate.session?(session, didUpdate: frame)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        for delegate in sceneViewDelegates {
            delegate.renderer?(renderer, didAdd: node, for: anchor)
        }
    }
}
