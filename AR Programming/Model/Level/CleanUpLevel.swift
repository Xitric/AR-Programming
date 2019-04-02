//
//  CleanUpLevel.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CleanUpLevel: Level {
    
    private var currentInventory = [Entity:[String:Int]]()
    private var goalInventory = [Entity:[String:Int]]()
    private var resetInventory = [Entity:[String:Int]]()
    
    private var entitiesForReset = [Entity:simd_double3]()
    
    private var collectibles: [Entity] {
        get {
            return entityManager.getEntities(withComponents: CollectibleComponent.self)
        }
    }
    
    private var dropOffs: [Entity] {
        get {
            return entityManager.getEntities(withComponents: InventoryComponent.self)
        }
    }
    
    override var infoLabel: String? {
        return getCurrentInventoryComparedToGoal()
    }
    
    private func getCurrentInventoryComparedToGoal() -> String {
        var inventoryComparedToGoal = ""
        for (entity, typeAmount) in currentInventory {
            for(type, amount) in typeAmount {
                if let goalAmount = goalInventory[entity]?[type] {
                    inventoryComparedToGoal.append("\(type) \(amount) / \(goalAmount)\n")
                }
            }
        }
        inventoryComparedToGoal.removeLast()
        return inventoryComparedToGoal
    }
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dropOffs = try container.decode([DropOffGoalJSON].self, forKey: .dropOffs)
        for dropoff in dropOffs {
            let entity = createDropOff(fromJson: dropoff)
            entityManager.addEntity(entity)
            let position = entity.component(subclassOf: TransformComponent.self)?.location
            entitiesForReset[entity] = position
        }
        
        let items = try container.decode([IemJSON].self, forKey: .items)
        for item in items {
            let entity = createItem(fromJson: item)
            entityManager.addEntity(entity)
            let position = entity.component(subclassOf: TransformComponent.self)?.location
            entitiesForReset[entity] = position
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
        
        let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1), offset: simd_double3(0, 0.05, 0))
        dropOff.addComponent(collision)
        
        let resource = ResourceComponent(resourceIdentifier: json.resourceIdentifier)
        dropOff.addComponent(resource)
        
        let inventory = InventoryComponent()
        dropOff.addComponent(inventory)
        
        currentInventory[dropOff] = json.collectiveGoals
        for (type, _) in json.collectiveGoals {
            inventory.add(quantity: 0, ofType: type)
            currentInventory[dropOff]![type] = 0
        }
        
        goalInventory[dropOff] = json.collectiveGoals
        resetInventory = currentInventory

        return dropOff
    }
    
    //MARK: - Logic
    override func update(delta: TimeInterval) {
        let dropOffCollisions = entityManager.getEntities(withComponents: CollisionComponent.self, InventoryComponent.self)
        // Only check if dropspot collides with an item when the player is not holding anything
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
                item.removeComponent(ofType: CollisionComponent.self)
    
                if isComplete() {
                    complete()
                }
            }
            delegate?.levelInfoChanged(self, info: infoLabel)
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

        return true
    }
    
    override func reset() {
        objc_sync_enter(entityManager)
        defer {
            objc_sync_exit(entityManager)
        }

        for oldEntity in collectibles {
            entityManager.removeEntity(oldEntity)
        }

        for oldEntity in dropOffs {
            entityManager.removeEntity(oldEntity)
        }
        
        if entityManager.player.component(ofType: LinkComponent.self) != nil {
            entityManager.player.removeComponent(ofType: LinkComponent.self)
        }
    
        for (newEntity, position) in entitiesForReset {
            newEntity.component(ofType: TransformComponent.self)?.location = position
            let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1), offset: simd_double3(0, 0.05, 0))
            newEntity.addComponent(collision)
            entityManager.addEntity(newEntity)
            print(newEntity.components)
        }
        
        currentInventory = resetInventory
        
        delegate?.levelInfoChanged(self, info: infoLabel)
        super.reset()
    }
    
    override func getScore() -> Int {
        return 0
    }
    
}

// MARK: - Helpers
private struct DropOffGoalJSON: Decodable {
    let x: Int
    let y: Int
    let resourceIdentifier: String
    let collectiveGoals: [String:Int]
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
