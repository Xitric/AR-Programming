//
//  LoopCard.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct LoopCard: Card {
    
    let name = "Gentag"
    let internalName = "loop"
    let summary = "Får en del af programmet til at gentage sig."
    let description = "Brug dette kort til at få en sekvens af kort til at gentage sig. Dette kort skal bruges sammen med et tal kort og et grænse kort."
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        return nil
    }
}
