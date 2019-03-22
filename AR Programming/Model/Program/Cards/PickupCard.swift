//
//  PickupCard.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

struct PickupCard: StatementCard {
    
    let name = "Saml op"
    let internalName = "pickup"
    let summary = "Få robotten til at samle noget op."
    let description = "Brug dette kort til at få robotten til at samle noget op. Robotten kan kun samle ting op, hvis den står oven på dem."
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        return PickupActionComponent()
    }
    
    func getContinuationIndex() -> Int {
        print("Pickup")
        return 0
    }
}
