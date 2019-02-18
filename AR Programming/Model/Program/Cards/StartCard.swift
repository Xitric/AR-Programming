//
//  StartCard.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct StartCard: StatementCard {
    
    let name = "Start"
    let internalName = "start"
    let summary = "Dit program starter her."
    let description = "Brug dette kort til at bestemme hvor programmet starter. Når programmet kører, vil det begynde ved dette kort."
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        return nil
    }
    
    func getContinuationIndex() -> Int {
        print("Start")
        return 0
    }
}