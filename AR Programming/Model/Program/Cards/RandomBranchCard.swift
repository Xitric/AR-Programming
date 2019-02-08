//
//  RandomBranchCard.swift
//  VisionCardTest
//
//  Created by user143563 on 2/1/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation
import SceneKit

struct RandomBranchCard: StatementCard {
    
    let name = "Tilfældig"
    let internalName = "randBranch"
    let summary = "Få programmet til at fortsætte i en tilfældig retning."
    let description = "Hvis du ikke helt kan beslutte dig for om du vil gøre én ting eller en anden, så brug dette kort til at vælge en tilfældig løsning ud af to muligheder."
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        return nil
    }
    
    func getContinuationIndex() -> Int {
        let choice = Int.random(in: 0...1)
        print("Branch went \(choice == 0 ? "up" : "down")")
        return choice
    }
}
