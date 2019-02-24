//
//  RandomBranchCard.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct RandomBranchCard: StatementCard {
    
    let name = "Tilfældig"
    let internalName = "randBranch"
    let summary = "Få programmet til at fortsætte i en tilfældig retning."
    let description = "Brug dette kort til at få programmet til at fortsætte i en tilfældig retning."
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        return nil
    }
    
    func getContinuationIndex() -> Int {
        let choice = Int.random(in: 0...1)
        print("Branch went \(choice == 0 ? "up" : "down")")
        return choice
    }
}
