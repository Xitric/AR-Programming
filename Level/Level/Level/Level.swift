//
//  Level.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class Level: LevelProtocol, Decodable {
    
    public let name: String
    public let levelNumber: Int
    public let levelType: String
    public var unlocked = false
    public var infoLabel: String? {
        return nil
    }
    public var entityManager: EntityManager
    public weak var delegate: LevelDelegate?
    
    private var lastUpdate = TimeInterval(0)
    var unlocks: Int?
    var levelRepository: LevelRepository?
    
    init(levelType: String, name: String, levelNumber: Int, unlocked: Bool, unlocks: Int?) {
        self.levelType = levelType
        self.name = name
        self.levelNumber = levelNumber
        self.unlocked = unlocked
        self.unlocks = unlocks
        self.entityManager = EntityManager()
    }
    
    public final func update(currentTime: TimeInterval) {
        objc_sync_enter(entityManager)
        defer {
            objc_sync_exit(entityManager)
        }
        
        let delta = currentTime - lastUpdate
        lastUpdate = currentTime
        
        entityManager.update(delta: delta)
        update(delta: delta)
    }
    
    public func isComplete() -> Bool {
        return false
    }
    
    public func getScore() -> Int {
        return 0
    }
    
    public func reset() {
        if let playerTransform = entityManager.player.component(subclassOf: TransformComponent.self) {
            playerTransform.location = simd_double3(0, 0, 0)
            playerTransform.rotation = simd_quatd(ix: 0, iy: 0, iz: 0, r: 1)
        }
        
        delegate?.levelReset(self)
    }
    
    func update(delta: TimeInterval) { }
    
    func complete() {
        if let unlocks = unlocks {
            levelRepository?.markLevel(withNumber: unlocks, asUnlocked: true, completion: nil)
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

// MARK: - Helpers
struct PropJSON: Decodable {
    let x: Double
    let y: Double
    let resourceIdentifier: String
}
