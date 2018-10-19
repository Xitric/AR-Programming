//
//  JumpCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class JumpCommand: CardCommand {
    func execute(modelIn3D animatableNode: AnimatableNode) {
        animatableNode.jump(by: 0.1, in: 0.3)
    }
}
