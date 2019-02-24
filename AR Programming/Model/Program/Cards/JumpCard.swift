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
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        let jump = SCNAction.moveBy(x: 0, y: CGFloat(0.1), z: 0, duration: TimeInterval(0.3))
        let gravity = SCNAction.moveBy(x: 0, y: CGFloat(-0.1), z:0, duration: TimeInterval(0.3))
        return SCNAction.sequence([jump, gravity])
    }
    
    func getContinuationIndex() -> Int {
        print("Jump")
        return 0
    }
}
