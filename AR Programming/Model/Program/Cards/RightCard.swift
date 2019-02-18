//
//  RightCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct RightCard: RotationCard {
    
    let name = "Højre"
    let internalName = "right"
    let summary = "Drej robotten til højre."
    let description = "Brug dette kort til at dreje robotten én gang mod højre - det er med urets retning. Brug rotationskortene til at ændre den retning, som robotten går i."
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        let axis = convert(axis: SCNVector3(0, 1, 0), to: robot)
        return rotationAction(by: -0.5 * Float.pi, around: axis)
    }
    
    func getContinuationIndex() -> Int {
        print("Right")
        return 0
    }
}
