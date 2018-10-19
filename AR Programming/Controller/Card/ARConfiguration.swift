//
//  ARConfiguration.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class ARConfiguration: NSObject {
    
    var sceneView: ARSCNView
    var configuration : ARWorldTrackingConfiguration?
    var options : ARSession.RunOptions?
    var cardWorld : CardWorld
    
    init(with scene: ARSCNView, with cards: CardWorld) {
        self.sceneView = scene
        self.cardWorld = CardWorld()
    }
    
    public func start() {
        if let conf = configuration, let opt = options {
            sceneView.session.run(conf, options: opt)
        }
    }
    
    public func stop() {
        sceneView.session.pause()
    }
}
