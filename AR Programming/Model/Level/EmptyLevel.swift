//
//  EmptyLevel.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 15/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class EmptyLevel: Level {
    init() {
         super.init(levelType: "Empty", name: "Frit spil", levelNumber: 0, unlocked: true, unlocks: "non", entityManager: EntityManager())
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
