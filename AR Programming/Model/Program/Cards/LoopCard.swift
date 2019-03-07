//
//  LoopCard.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct LoopCard: StatementCard {
    
    let name = "Loop"
    let internalName = "loop"
    let summary = "Dit program looper her."
    let description = "Brug dette kort til at loope."
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        return nil
    }
    
    func getContinuationIndex() -> Int {
        print("Loop")
        return 0
    }
}
