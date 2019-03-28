//
//  MoveAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class MoveAction: ComponentAction {
    
    override func getActionComponent(forEntity entity: Entity) -> ActionComponent? {
        return MovementActionComponent(movement: simd_double3(1, 0, 0), duration: 1.5)
    }
}
