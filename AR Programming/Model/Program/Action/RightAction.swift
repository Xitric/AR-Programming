//
//  RightAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class RightAction: ComponentAction {
    
    override func getActionComponent(forEntity entity: Entity) -> ActionComponent? {
        guard let transform = entity.component(subclassOf: TransformComponent.self)
            else { return nil }

        let rotation = simd_quatd(angle: -0.5 * Double.pi, axis: simd_double3(0, 1, 0))
        return RotationActionComponent(from: transform.rotation,
                                       by: rotation,
                                       duration: 1.5)
    }
}
