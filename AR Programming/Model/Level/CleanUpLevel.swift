//
//  CleanUpLevel.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CleanUpLevel: Level {
    
    //private var dropOffGoals = [String:simd_double3]()
    //private var dropOffAmounts = [String:Int]()
    //private var collect = [String:[Entity]]()
    
    
    private var currentInventory = [Entity:[String:Int]]()
    private var goalInventory = [Entity:[String:Int]]()
    
    private var collectibles: [Entity] {
        get {
            return entityManager.getEntities(withComponents: CollectibleComponent.self)
        }
    }
    
    private var collectiblesForReset = [Entity]()
    
    override var infoLabel: String? {
        return "infoLabl"
    }
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dropOffs = try container.decode([DropOffGoalJSON].self, forKey: .dropOffs)
        for dropoff in dropOffs {
            let entity = createDropOff(fromJson: dropoff)
            entityManager.addEntity(entity)
        }
//        save(goals: dropOffs)
        
        
        
        let items = try container.decode([IemJSON].self, forKey: .items)
        for item in items {
            let entity = createItem(fromJson: item)
            entityManager.addEntity(entity)
           // collectiblesForReset.append(entity)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case dropOffs
        case items
    }
    
    private func createItem(fromJson json: IemJSON) -> Entity {
        let item = Entity()
        
        let collectible = CollectibleComponent()
        item.addComponent(collectible)
        
        let transform = TransformComponent(location: simd_double3(x: Double(json.x), y: 0, z: Double(json.y)))
        item.addComponent(transform)
        
        let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1), offset: simd_double3(0, 0.05, 0))
        item.addComponent(collision)
        
        let resource = ResourceComponent(resourceIdentifier: json.resourceIdentifier)
        item.addComponent(resource)
        
        let quantity = QuantityComponent(type: json.type, quantity: json.quantity)
        item.addComponent(quantity)
        
        let spin = SpinComponent(speed: 0.02)
        item.addComponent(spin)
        
        return item
    }

    private func createDropOff(fromJson json: DropOffGoalJSON) -> Entity {
        let dropOff = Entity()

        let transform = TransformComponent(location: simd_double3(x: Double(json.x), y: 0, z: Double(json.y)))
        dropOff.addComponent(transform)

        let inventory = InventoryComponent()
        inventory.add(quantity: 0, ofType: json.type)
        dropOff.addComponent(inventory)
        
        let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1), offset: simd_double3(0, 0.05, 0))
        dropOff.addComponent(collision)
        
        let resource = ResourceComponent(resourceIdentifier: json.resourceIdentifier)
        dropOff.addComponent(resource)
        
        goalInventory[dropOff] = [json.type:json.amount]
        currentInventory[dropOff] = [json.type:0]

        return dropOff
    }

    //MARK: - Logic
    override func update(delta: TimeInterval) {
        let dropOffCollisions = entityManager.getEntities(withComponents: CollisionComponent.self, InventoryComponent.self)
        if entityManager.player.component(ofType: LinkComponent.self) == nil {
        for dropoff in dropOffCollisions {
            if let dropoffCollision = dropoff.component(ofType: CollisionComponent.self) {
                for collectible in collectibles {
                    if let collectibleCollision = collectible.component(ofType: CollisionComponent.self) {
                        if dropoffCollision.collidesWith(other: collectibleCollision){
                            addToDropoff(dropoff, collectible)
                            
                        }
                    }
                }
            }
            }
        }
    }
    
    private func addToDropoff(_ dropoff: Entity, _ item: Entity) {
        if let quantity = item.component(ofType: QuantityComponent.self),
            let dropoffInventory = dropoff.component(ofType: InventoryComponent.self) {
            
            dropoffInventory.add(quantity: quantity.quantity, ofType: quantity.type)

            if (currentInventory[dropoff]?[quantity.type]) != nil{
                currentInventory[dropoff]?[quantity.type]? += quantity.quantity
                item.removeComponent(ofType: QuantityComponent.self)
                item.removeComponent(ofType: CollectibleComponent.self)
            }
            
            delegate?.levelInfoChanged(self, info: infoLabel)
            
            if isComplete() {
                complete()
            }
        }
    }
    
    
    override func isComplete() -> Bool {
        for (entity, dict) in currentInventory {
            for (type, value) in dict {
                var typeGoal = goalInventory[entity]!
                if (typeGoal[type] != value) {
                    return false
                }
            }
        }
//        for entity in collectibles {
//            guard let entityPosition = entity.component(subclassOf: TransformComponent.self)?.location else { return false }
//
//            for (type, goalPosition) in dropOffGoals {
//                if !simd_double3.vectEqual(entityPosition, goalPosition, tolerance: 0.1){
//                    return false
//                }
//            }
//        }
        return true
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
private struct DropOffGoalJSON: Decodable {
    let type: String
    let x: Int
    let y: Int
    let amount: Int
    let resourceIdentifier: String
}

private struct IemJSON: Decodable {
    let type: String
    let x: Int
    let y: Int
    let quantity: Int
    let resourceIdentifier: String
}

// MARK: - LevelFactory
class CleanUpLevelFactory: LevelFactory {
    
    func canReadLevel(ofType levelType: String) -> Bool {
        return "cleanup" == levelType
    }
    
    func initLevel(json: Data) throws -> Level {
        return try JSONDecoder().decode(CleanUpLevel.self, from: json)
    }
}
