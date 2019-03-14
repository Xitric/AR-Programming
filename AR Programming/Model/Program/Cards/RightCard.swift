//
//  RightCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct RightCard: StatementCard {
    
    let name = "Højre"
    let internalName = "right"
    let summary = "Drej robotten til højre."
    let description = "Brug dette kort til at dreje robotten én gang mod højre - det er med urets retning. Brug rotationskortene til at ændre den retning, som robotten går i."
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        guard let transform = entity.component(subclassOf: TransformComponent.self)
            else { return nil }
        
        let rotation = simd_quatd(angle: -0.5 * Double.pi, axis: simd_double3(0, 1, 0))
        return RotationActionComponent(from: transform.rotation,
                                       by: rotation,
                                       duration: 1.5)
    }
    
    func getContinuationIndex() -> Int {
        print("Right")
        return 0
    }
}
