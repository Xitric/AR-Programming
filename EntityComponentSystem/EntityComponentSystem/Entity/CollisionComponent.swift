//
//  CollisionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 15/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

public class CollisionComponent: GKComponent {

    let size: simd_double3
    let offset: simd_double3

    public init(size: simd_double3, offset: simd_double3 = simd_double3(0, 0, 0)) {
        self.size = size
        self.offset = offset
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func collidesWith(other: CollisionComponent) -> Bool {
        guard let selfTransform = entity?.component(subclassOf: TransformComponent.self),
            let otherTransform = other.entity?.component(subclassOf: TransformComponent.self)
            else { return false }

        let xMaxDist = self.size.x / 2 + other.size.x / 2
        let yMaxDist = self.size.y / 2 + other.size.y / 2
        let zMaxDist = self.size.z / 2 + other.size.z / 2

        let xDist = abs(selfTransform.location.x + offset.x - otherTransform.location.x - other.offset.x)
        let yDist = abs(selfTransform.location.y + offset.y - otherTransform.location.y - other.offset.y)
        let zDist = abs(selfTransform.location.z + offset.z - otherTransform.location.z - other.offset.z)

        return xDist <= xMaxDist &&
            yDist <= yMaxDist &&
            zDist <= zMaxDist
    }
}
