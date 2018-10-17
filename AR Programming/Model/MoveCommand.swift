//
//  MoveCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class MoveCommand: CardCommand {
    func execute(modelIn3D animatableNode: AnimatableNode) {
        animatableNode.move(by: SCNVector3(x:2, y:0, z:0))
    }
}
