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
    
    init(levelType: String, name: String, levelNumber: Int, unlocked: Bool, unlocks: String?, entityManager: EntityManager) {
        self.levelType = levelType
        self.name = name
        self.levelNumber = levelNumber
        self.unlocked = unlocked
        self.unlocks = unlocks
        self.entityManager = entityManager
    }
    
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
        if let playerTransform = entityManager.player.component(subclassOf: TransformComponent.self) {
            playerTransform.location = simd_double3(0, 0, 0)
            playerTransform.rotation = simd_quatd(ix: 0, iy: 0, iz: 0, r: 1)
            playerTransform.scale = simd_double3(1, 1, 1)
        }
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

// MARK: - Hashable
extension Level: Hashable {
    
    static func == (lhs: Level, rhs: Level) -> Bool {
        return lhs.levelType == rhs.levelType &&
            lhs.name == rhs.name &&
            lhs.levelNumber == rhs.levelNumber
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(levelType)
        hasher.combine(name)
        hasher.combine(levelNumber)
    }
}

protocol LevelDelegate: class {
    func levelCompleted(_ level: Level)
    func levelReset(_ level: Level)
}
