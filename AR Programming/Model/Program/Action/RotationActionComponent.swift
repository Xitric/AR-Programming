//
//  RotationActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class RotationActionComponent: ActionComponent {
    
    let startRotation: simd_quatd
    let goalRotation: simd_quatd
    let duration: TimeInterval
    private var elapsedTime = TimeInterval(0)
    
    init(from start: simd_quatd, by rotation: simd_quatd, duration: TimeInterval) {
        self.startRotation = start
        self.goalRotation = start * rotation
        self.duration = duration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let transform = entity?.component(subclassOf: TransformComponent.self)
            else { return }
        
        elapsedTime = min(elapsedTime + seconds, duration)
        let t = elapsedTime / duration
        
        transform.rotation = simd_slerp(startRotation, goalRotation, t)
        
        if elapsedTime  == duration {
            complete()
        }
    }
}
