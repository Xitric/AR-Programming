//
//  JumpCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class JumpCommand: CardCommand {
    func execute(modelIn3D animatableNode: AnimatableNode) -> SCNAction {
        let jump = SCNAction.moveBy(x: 0, y: CGFloat(0.1), z: 0, duration: TimeInterval(0.3))
        let gravity = SCNAction.moveBy(x: 0, y: CGFloat(-0.1), z:0, duration: TimeInterval(0.3))
        return SCNAction.sequence([jump, gravity])
    }
}
