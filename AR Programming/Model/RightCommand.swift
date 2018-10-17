//
//  RightCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class RightCommand: CardCommand {
    func execute(modelIn3D animatableNode: AnimatableNode) {
        animatableNode.rotate(by: 0.5*Float.pi, around: SCNVector3(0, 1, 0))
    }
}
