//
//  EmptyLevel.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 15/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

//No need for a separate Level subclass, since the Empty level does not do anything

// MARK: - LevelFactory
class EmptyLevelFactory: LevelFactory {
    
    func canReadLevel(ofType levelType: String) -> Bool {
        return "empty" == levelType
    }
    
    func initLevel(json: Data) throws -> Level {
        return try JSONDecoder().decode(Level.self, from: json)
    }
}
