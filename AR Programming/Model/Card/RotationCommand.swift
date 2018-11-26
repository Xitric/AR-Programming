//
//  RotationCommand.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 30/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

protocol RotationCommand: CardCommand {
    
}

extension RotationCommand {
    public func rotationAction(by rotation: Float, around axis: SCNVector3) -> SCNAction {
        return SCNAction.rotate(by: CGFloat(rotation), around: axis, duration: TimeInterval(1.5))
    }
}
