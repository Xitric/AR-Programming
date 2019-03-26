//
//  BorderCard.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct BorderCard: Card {
    
    let name = "Grænse"
    let internalName = "block"
    let summary = "Dit loop program stopper her."
    let description = "Brug dette kort til at vise slutningen på gentagelsen."
    let type = CardType.control
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        return nil
    }
}
