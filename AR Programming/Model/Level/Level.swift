//
//  Level.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class Level: Decodable, UpdateDelegate {
    
    private var lastUpdate = TimeInterval(0)
    
    let levelType: String
    let name: String
    let levelNumber: Int
    var unlocked = false
    var unlocks: String?
    var entityManager: EntityManager
    
    weak var delegate: LevelDelegate?
    
    func update(currentTime: TimeInterval) {
        let delta = currentTime - lastUpdate
        lastUpdate = currentTime
        
        entityManager.update(delta: delta)
        update(delta: delta)
    }
    
    func update(delta: TimeInterval) {
        
    }
    
    func isComplete() -> Bool {
        return false
    }
    
    func getScore() -> Int {
        return 0
    }
    
    func reset() {
        
    }
    
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
