//
//  DropCard.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

struct DropCard: StatementCard {
    
    let name = "Smid"
    let internalName = "drop"
    let summary = "Få robotten til at smide det den holder i hænderne."
    let description = "Brug dette kort til at få robotten til at smide det den har i hænderne. Robotten smider tingene der hvor den står."
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        return DropActionComponent()
    }
    
    func getContinuationIndex() -> Int {
        print("Drop")
        return 0
    }
}
