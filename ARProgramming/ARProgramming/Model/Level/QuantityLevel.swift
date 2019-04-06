//
//  QuantityLevel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class QuantityLevel: Level {
    
    private var goalQuantities = [String:Int]()
    private var avoidables = [String]()
    private var collectibles: [Entity] {
        get {
            return entityManager.getEntities(withComponents: QuantityComponent.self)
        }
    }
    private var collectiblesForReset = [Entity]()
    private var isMissingCollectibles: Bool {
        for (type, goal) in goalQuantities {
            if collectedQuantity(forType: type) < goal {
                return true
            }
        }
        
        return false
    }
    private var hasCollectedTooMuch: Bool {
        for (type, goal) in goalQuantities {
            if collectedQuantity(forType: type) > goal {
                return true
            }
        }
        
        return false
    }
    private var hasCollectedAvoidables: Bool {
        for type in avoidables {
            if collectedQuantity(forType: type) != 0 {
                return true
            }
        }
        
        return false
    }
    
    override var infoLabel: String? {
        if hasCollectedAvoidables {
            return "Du har samlet noget, du ikke måtte samle!"
        } else if hasCollectedTooMuch {
            return "Du har samlet for meget!"
        } else if isMissingCollectibles {
            var label = "Du har samlet"
            
            for (type, goal) in goalQuantities {
                label += " \(collectedQuantity(forType: type))/\(goal) \(type),"
            }
            
            _ = label.popLast()
            
            if avoidables.count != 0 {
                label += ". Du skal undgå"
                
                for type in avoidables {
                    label += " \(type),"
                }
                
                _ = label.popLast()
            }
            
            label += "."
            
            return label
        }
        
        return nil
    }
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let collectionGoals = try container.decode([CollectibleGoalJSON].self, forKey: .doCollect)
        store(collectionGoals: collectionGoals, into: &goalQuantities)
        
        avoidables = try container.decode([String].self, forKey: .dontCollect)
        
        let collectibles = try container.decode([CollectibleJSON].self, forKey: .collectibles)
        for collectible in collectibles {
            let entity = createCollectible(fromJson: collectible)
            entityManager.addEntity(entity)
            collectiblesForReset.append(entity)
        }
        
        //This is used to keep track of how much the player has collected
        entityManager.player.addComponent(InventoryComponent())
    }
    
    private func store(collectionGoals: [CollectibleGoalJSON], into dict: inout [String:Int]) {
        for goal in collectionGoals {
            dict[goal.type] = goal.quantity
        }
    }
    
    private func createCollectible(fromJson json: CollectibleJSON) -> Entity {
        let collectible = Entity()
        
        let transform = TransformComponent(location: simd_double3(x: Double(json.x), y: 0, z: Double(json.y)))
        collectible.addComponent(transform)
        
        let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1), offset: simd_double3(0, 0.05, 0))
        collectible.addComponent(collision)
        
        let quantity = QuantityComponent(type: json.type, quantity: json.quantity)
        collectible.addComponent(quantity)
        
        let resource = ResourceComponent(resourceIdentifier: json.resourceIdentifier)
        collectible.addComponent(resource)
        
        let spin = SpinComponent(speed: 0.02)
        collectible.addComponent(spin)
        
        return collectible
    }
    
    private enum CodingKeys: String, CodingKey {
        case doCollect
        case dontCollect
        case collectibles
    }
    
    //MARK: - Logic
    override func update(delta: TimeInterval) {
        guard let playerCollision = entityManager.player.component(ofType: CollisionComponent.self)
            else { return }

        for collectible in collectibles {
            if let collectibleCollision = collectible.component(ofType: CollisionComponent.self) {
                if playerCollision.collidesWith(other: collectibleCollision) {
                    collect(collectible)
                    delegate?.levelInfoChanged(self, info: infoLabel)
                    
                    if isComplete() {
                        complete()
                    }
                }
            }
        }
    }
    
    private func collect(_ entity: Entity) {
        entityManager.removeEntity(entity)
        
        if let quantityComponent = entity.component(ofType: QuantityComponent.self),
            let playerInventory = entityManager.player.component(ofType: InventoryComponent.self) {
            
            let type = quantityComponent.type
            let quantity = quantityComponent.quantity
            playerInventory.add(quantity: quantity, ofType: type)
        }
    }
    
    override func isComplete() -> Bool {
        for (type, goal) in goalQuantities {
            if collectedQuantity(forType: type) != goal {
                return false
            }
        }
        
        for type in avoidables {
            if collectedQuantity(forType: type) != 0 {
                return false
            }
        }
        
        return true
    }
    
    private func collectedQuantity(forType type: String) -> Int {
        return entityManager.player.component(ofType: InventoryComponent.self)?.quantities[type] ?? 0
    }
    
    override func getScore() -> Int {
        return 0
    }
    
    override func reset() {
        objc_sync_enter(entityManager)
        defer {
            objc_sync_exit(entityManager)
        }
        
        entityManager.player.component(ofType: InventoryComponent.self)?.reset()
        
        for oldEntity in collectibles {
            entityManager.removeEntity(oldEntity)
        }
        
        for newEntity in collectiblesForReset {
            entityManager.addEntity(newEntity)
        }
        
        super.reset()
        
        delegate?.levelInfoChanged(self, info: infoLabel)
    }
}

// MARK: - Helpers
private struct CollectibleGoalJSON: Decodable {
    let type: String
    let quantity: Int
}

private struct CollectibleJSON: Decodable {
    let x: Int
    let y: Int
    let quantity: Int
    let resourceIdentifier: String
    let type: String
}

// MARK: - LevelFactory
class QuantityLevelFactory: LevelFactory {
    
    func canReadLevel(ofType levelType: String) -> Bool {
        return "quantity" == levelType
    }
    
    func initLevel(json: Data) throws -> Level {
        return try JSONDecoder().decode(QuantityLevel.self, from: json)
    }
}
