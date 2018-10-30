//
//  LeftCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class LeftCommand: RotationCommand {
    func execute(modelIn3D animatableNode: AnimatableNode) -> SCNAction {
        let axis = convert(axis: SCNVector3(0, 1, 0), to: animatableNode.model)
        return rotationAction(by: -0.5 * Float.pi, around: axis)
    }
}
