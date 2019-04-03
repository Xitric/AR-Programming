//
//  MovementActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class MovementActionComponent: ActionComponent {
    
    let goalMovement: simd_double3
    private var elapsedMovement = simd_double3(0, 0, 0)
    let duration: TimeInterval
    
    init(movement: simd_double3, duration: TimeInterval) {
        self.goalMovement = movement
        self.duration = duration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let transform = entity?.component(subclassOf: TransformComponent.self)
            else { return }
        
        var reachedGoal = false
        
        var movement = (seconds / duration) * goalMovement
        if (simd_length(elapsedMovement + movement) >= simd_length(goalMovement)) {
            movement = goalMovement - elapsedMovement
            reachedGoal = true
        }
        
        elapsedMovement += movement
        transform.location += transform.rotation.act(movement)
        
        if reachedGoal {
            complete()
        }
    }
}
