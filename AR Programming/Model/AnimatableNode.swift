//
//  AnimatableNode.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

//TODO: Reference to article here
class AnimatableNode {
    
    private(set) var model : SCNNode
    
    init(modelSource: String) {
        let scene = SCNScene(named: modelSource)
        model = scene!.rootNode
    }
    
    //TODO: Speed
    public func move(by movement: SCNVector3) {
        let action = SCNAction.move(by: movement, duration: TimeInterval(3))
        model.runAction(action)
    }
    
    public func rotate(by angle: Float, around axis: SCNVector3) {
        let action = SCNAction.rotate(by: CGFloat(angle), around: axis, duration: TimeInterval(100))
        model.runAction(action)
    }
}
