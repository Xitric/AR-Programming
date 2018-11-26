//
//  CardCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

protocol CardCommand {
    func execute(modelIn3D animatableNode: AnimatableNode) -> SCNAction
}

extension CardCommand {
    public func convert(axis: SCNVector3, to node: SCNNode) -> SCNVector3 {
        var convertedAxis = axis
        
        if let parent = node.parent {
            convertedAxis = node.convertVector(axis, to: parent)
        }
        
        return convertedAxis
    }
}
