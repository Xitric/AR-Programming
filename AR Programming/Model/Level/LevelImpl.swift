//
//  Level.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

typealias Level = LevelProtocol & LevelImpl

class LevelImpl: Decodable {
    
    let levelType: String
    let name: String
    let levelNumber: Int
    var unlocked = false
    var unlocks: String?
    var entityManager: EntityManager
    
    weak var delegate: LevelDelegate?
    
    //MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        levelType = try container.decode(String.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        levelNumber = try container.decode(Int.self, forKey: .number)
        unlocks = try? container.decode(String.self, forKey: .unlocks)
        
        entityManager = EntityManager()
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case number
        case unlocks
    }
}
