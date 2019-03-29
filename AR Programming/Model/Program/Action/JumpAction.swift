//
//  JumpAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class JumpAction: ComponentAction {
    
    override func getActionComponent() -> ActionComponent? {
        let jump = MovementActionComponent(movement: simd_double3(0, 1 * strength, 0), duration: 0.3 * strength)
        let gravity = MovementActionComponent(movement: simd_double3(0, -1 * strength, 0), duration: 0.3 * strength)
        return CompoundActionComponent(jump, gravity)
    }
}
