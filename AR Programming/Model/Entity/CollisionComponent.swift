//
//  CollisionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 15/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CollisionComponent: GKComponent {
    
    let size: simd_double3
    
    init(size: simd_double3) {
        self.size = size
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collidesWith(other: CollisionComponent) -> Bool {
        guard let selfTransform = entity?.component(subclassOf: TransformComponent.self),
            let otherTransform = other.entity?.component(subclassOf: TransformComponent.self)
            else { return false }
        
        let xMaxDist = self.size.x / 2 + other.size.x / 2
        let yMaxDist = self.size.y / 2 + other.size.y / 2
        let zMaxDist = self.size.z / 2 + other.size.z / 2
        
        let xDist = abs(selfTransform.location.x - otherTransform.location.x)
        let yDist = abs(selfTransform.location.y - otherTransform.location.y)
        let zDist = abs(selfTransform.location.z - otherTransform.location.z)
        
        return xDist <= xMaxDist &&
            yDist <= yMaxDist &&
            zDist <= zMaxDist
    }
}
