//
//  LeftCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct LeftCard: RotationCard {
    
    let name = "Venstre"
    let internalName = "left"
    let summary = "Drej robotten til venstre."
    let description = "Brug dette kort til at dreje robotten én gang mod venstre - det er mod urets retning. Brug rotationskortene til at ændre den retning, som robotten går i."
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        let axis = convert(axis: SCNVector3(0, 1, 0), to: robot)
        return rotationAction(by: 0.5 * Float.pi, around: axis)
    }
    
    func getContinuationIndex() -> Int {
        print("Left")
        return 0
    }
}
