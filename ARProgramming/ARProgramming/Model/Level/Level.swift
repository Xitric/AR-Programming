//
//  Level.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class Level: Decodable, UpdateDelegate {
    
    private var lastUpdate = TimeInterval(0)
    
    let levelType: String
    let name: String
    let levelNumber: Int
    var unlocked = false
    var unlocks: Int?
    var infoLabel: String? {
        return nil
    }
    var entityManager: EntityManager
    
    weak var delegate: LevelDelegate?
    
    init(levelType: String, name: String, levelNumber: Int, unlocked: Bool, unlocks: Int?) {
        self.levelType = levelType
        self.name = name
        self.levelNumber = levelNumber
        self.unlocked = unlocked
        self.unlocks = unlocks
        self.entityManager = EntityManager()
    }
    
    final func update(currentTime: TimeInterval) {
        objc_sync_enter(entityManager)
        defer {
            objc_sync_exit(entityManager)
        }
        
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
        }
        
        delegate?.levelReset(self)
    }
    
    func complete() {
        if let unlocks = unlocks {
            LevelManager.markLevel(withNumber: unlocks, asUnlocked: true)
        }
        delegate?.levelCompleted(self)
    }
    
    //MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        levelType = try container.decode(String.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        levelNumber = try container.decode(Int.self, forKey: .number)
        unlocks = try? container.decode(Int.self, forKey: .unlocks)
        entityManager = EntityManager()
        
        let props = try container.decode([PropJSON].self, forKey: .props)
        for prop in props {
            let propEntity = createProp(fromJson: prop)
            entityManager.addEntity(propEntity)
        }
    }
    
    private func createProp(fromJson propJson: PropJSON) -> Entity {
        let prop = Entity()
        
        let transform = TransformComponent(location: simd_double3(propJson.x, 0, propJson.y))
        prop.addComponent(transform)
        
        let resource = ResourceComponent(resourceIdentifier: propJson.resourceIdentifier)
        prop.addComponent(resource)
        
        return prop
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case number
        case unlocks
        case props
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

struct PropJSON: Decodable {
    let x: Double
    let y: Double
    let resourceIdentifier: String
}

protocol LevelDelegate: class {
    func levelCompleted(_ level: Level)
    func levelReset(_ level: Level)
    func levelInfoChanged(_ level: Level, info: String?)
}
