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
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        let movement = convert(axis: SCNVector3(x:0.5, y:0, z:0), to: robot)
        return SCNAction.move(by: movement, duration: TimeInterval(1.5))
    }
    
    func getContinuationIndex() -> Int {
        print("Move")
        return 0
    }
}
