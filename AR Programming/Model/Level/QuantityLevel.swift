//
//  QuantityLevel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class QuantityLevel: Level {
    
    private let goalQuantity: Int
    private var currentlyCollected: Int {
        get {
            return entityManager.player.component(ofType: QuantityComponent.self)?.quantity ?? 0
        }
        set {
            entityManager.player.component(ofType: QuantityComponent.self)?.quantity = newValue
        }
    }
    private var collectibles: [Entity] {
        get {
            //The player also has a QuantityComponent, so we exclude the player entity
            return entityManager.getEntities(withComponents: QuantityComponent.self).filter { $0 !== entityManager.player }
        }
    }
    private var collectibleForReset = [Entity]()
    
    override var infoLabel: String? {
        if currentlyCollected <= goalQuantity {
            return "Du har samlet \(currentlyCollected)/\(goalQuantity)"
        } else {
            return "Du har samlet \(currentlyCollected), og det er for meget!"
        }
    }
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        goalQuantity = try container.decode(Int.self, forKey: .goalQuantity)
        let resourceIdentifier = try container.decode(String.self, forKey: .resource)
        try super.init(from: decoder)
        
        let collectibles = try container.decode([CollectibleJSON].self, forKey: .collectibles)
        for collectible in collectibles {
            let entity = createCollectible(fromJson: collectible, withResource: resourceIdentifier)
            entityManager.addEntity(entity)
            collectibleForReset.append(entity)
        }
        
        //This is used to keep track of how much the player has collected
        entityManager.player.addComponent(QuantityComponent(quantity: 0))
    }
    
    private func createCollectible(fromJson json: CollectibleJSON, withResource resourceIdentifier: String) -> Entity {
        let collectible = Entity()
        
        let transform = TransformComponent()
        transform.location = simd_double3(x: Double(json.x), y: 0, z: Double(json.y))
        collectible.addComponent(transform)
        
        let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1))
        collectible.addComponent(collision)
        
        let quantity = QuantityComponent(quantity: json.quantity)
        collectible.addComponent(quantity)
        
        let resource = ResourceComponent(resourceIdentifier: "\(resourceIdentifier)\(json.quantity)")
        collectible.addComponent(resource)
        
        let spin = SpinComponent(speed: 0.02)
        collectible.addComponent(spin)
        
        return collectible
    }
    
    private enum CodingKeys: String, CodingKey {
        case goalQuantity
        case resource
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
        
        let quantity = entity.component(ofType: QuantityComponent.self)?.quantity ?? 0
        currentlyCollected = currentlyCollected + quantity
    }
    
    override func isComplete() -> Bool {
        return currentlyCollected == goalQuantity
    }
    
    override func getScore() -> Int {
        return 0
    }
    
    override func reset() {
        currentlyCollected = 0
        
        for oldEntity in collectibles {
            entityManager.removeEntity(oldEntity)
        }
        
        for newEntity in collectibleForReset {
            entityManager.addEntity(newEntity)
        }
        
        super.reset()
        
        delegate?.levelInfoChanged(self, info: infoLabel)
    }
}

// MARK: - Helpers
private struct CollectibleJSON: Decodable {
    let x: Int
    let y: Int
    let quantity: Int
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
