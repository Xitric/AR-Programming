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
        var convertedMovement = movement
        
        if let parent = model.parent {
            convertedMovement = model.convertVector(movement, to: parent)
        }
        
        let action = SCNAction.move(by: convertedMovement, duration: TimeInterval(3))
        model.runAction(action)
    }
    
    public func rotate(by angle: Float, around axis: SCNVector3) {
        var convertedAxis = axis
        
        if let parent = model.parent {
            convertedAxis = model.convertVector(axis, to: parent)
        }
        
        let action = SCNAction.rotate(by: CGFloat(angle), around: convertedAxis, duration: TimeInterval(3))
        model.runAction(action)
    }
}
