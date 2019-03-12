//
//  LeftCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct LeftCard: StatementCard {
    
    let name = "Venstre"
    let internalName = "left"
    let summary = "Drej robotten til venstre."
    let description = "Brug dette kort til at dreje robotten én gang mod venstre - det er mod urets retning. Brug rotationskortene til at ændre den retning, som robotten går i."
    
    func getAction() -> ActionComponent? {
        return RotateActionComponent(rotation: simd_quatd(angle: 0.5 * Double.pi, axis: simd_double3(0, 1, 0)), duration: 1.5)
    }
    
    func getContinuationIndex() -> Int {
        print("Left")
        return 0
    }
}
