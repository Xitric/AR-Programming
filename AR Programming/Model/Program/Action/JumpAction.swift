//
//  JumpAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class JumpAction: ComponentAction {
    
    override func getActionComponent(forEntity entity: Entity) -> ActionComponent? {
        let jump = MovementActionComponent(movement: simd_double3(0, 1, 0), duration: 0.3)
        let gravity = MovementActionComponent(movement: simd_double3(0, -1, 0), duration: 0.3)
        return CompoundActionComponent(jump, gravity)
    }
}
