//
//  SpinComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 18/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class SpinComponent: GKComponent {
    
    let axis: simd_double3
    let speed: Double
    
    init(axis: simd_double3, speed: Double) {
        self.axis = axis
        self.speed = speed
        super.init()
    }
    
    convenience init(speed: Double) {
        self.init(axis: simd_double3(0, 1, 0), speed: speed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let transform = entity?.component(subclassOf: TransformComponent.self)
            else { return }
        
        transform.rotation *= simd_quatd(angle: speed, axis: axis)
    }
}
