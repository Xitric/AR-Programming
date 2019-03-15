//
//  JumpCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct JumpCard: StatementCard {
    
    let name = "Hop"
    let internalName = "jump"
    let summary = "Få robotten til at hoppe."
    let description = "Skal du nå noget der hænger oppe i luften? Når robotten ser dette kort, vil den lave et lille hop."
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        let jump = MovementActionComponent(movement: simd_double3(0, 1, 0), duration: 0.3)
        let gravity = MovementActionComponent(movement: simd_double3(0, -1, 0), duration: 0.3)
        return CompoundActionComponent(jump, gravity)
    }
    
    func getContinuationIndex() -> Int {
        print("Jump")
        return 0
    }
}
