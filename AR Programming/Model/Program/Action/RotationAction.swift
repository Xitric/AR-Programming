//
//  RotationAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 29/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class RotationAction: ComponentAction {
    
    let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    override func getActionComponent() -> ActionComponent? {
        var action: ActionComponent?
        
        //We can not rotate by more than 180 degrees at a time, so we construct a CompoundActionComponent if we have to rotate by more
        for i in stride(from: 0, to: strength, by: 2) {
            let rotationAmount = min(strength - i, 2)
            let rotation = simd_quatd(angle: 0.5 * Double.pi * rotationAmount * direction.rawValue, axis: simd_double3(0, 1, 0))
            let rotationAction = RotationActionComponent(by: rotation,
                                                         duration: 1.5 * rotationAmount)
            
            if let currentAction = action {
                action = CompoundActionComponent(currentAction, rotationAction)
            } else {
                action = rotationAction
            }
        }
        
        return action
    }
    
    enum Direction: Double {
        case left = 1
        case right = -1
    }
}
