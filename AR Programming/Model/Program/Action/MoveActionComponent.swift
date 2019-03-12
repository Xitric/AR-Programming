//
//  MoveActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class MoveActionComponent: ActionComponent {
    
    let movement: simd_double3
    
    init(movement: simd_double3, duration: TimeInterval) {
        self.movement = movement
        super.init(duration: duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
