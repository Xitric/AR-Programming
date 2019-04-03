//
//  MoveAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class MoveAction: ComponentAction {
    
    override func getActionComponent() -> ActionComponent? {
        return MovementActionComponent(movement: simd_double3(strength, 0, 0), duration: 1.5 * strength)
    }
}
