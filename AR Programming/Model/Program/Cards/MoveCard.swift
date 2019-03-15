//
//  MoveCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct MoveCard: StatementCard {
    
    let name = "Gå"
    let internalName = "move"
    let summary = "Få robotten til at gå frem."
    let description = "Når robotten ser dette kort, vil den tage ét skridt frem. Brug rotationskortene til at ændre robottens retning. Hvis robotten skal gå længere frem så brug dette kort flere gange."
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        return MovementActionComponent(movement: simd_double3(2, 0, 0), duration: 1.5)
    }
    
    func getContinuationIndex() -> Int {
        print("Move")
        return 0
    }
}
