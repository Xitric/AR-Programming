//
//  CleanUpLevel.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class CleanUpLevel: Level {

    private var currentInventory = [Entity: [String: Int]]()
    private var goalInventory = [Entity: [String: Int]]()
    private var resetInventory = [Entity: [String: Int]]()

    private var entitiesForReset = [Entity: simd_double3]()

    private var collectibles: [Entity] {
        return entityManager.getEntities(withComponents: CollectibleComponent.self)
    }

    private var dropSpots: [Entity] {
        return entityManager.getEntities(withComponents: InventoryComponent.self)
    }

    override var infoLabel: String? {
        if !goalInventory.isEmpty {
            return getCurrentInventoryComparedToGoal()
        }
        return nil
    }

    private func getCurrentInventoryComparedToGoal() -> String {
        var inventoryComparedToGoal = "Sæt tingene på plads\n"
        var tempArray = [String]()
        for (entity, typeAmount) in currentInventory {
            for(type, amount) in typeAmount {
                if let goalAmount = goalInventory[entity]?[type] {
                    tempArray.append("\(type) \(amount) / \(goalAmount)")
                }
            }
            tempArray.sort()
        }
        for string in tempArray {
            inventoryComparedToGoal.append(string + "\n")
        }
        inventoryComparedToGoal.removeLast()
        return inventoryComparedToGoal
    }

    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dropSpots = try container.decode([DropSpotGoalJSON].self, forKey: .dropSpots)
        for dropSpot in dropSpots {
            let entity = createDropSpots(fromJson: dropSpot)
            entityManager.addEntity(entity)
            let position = entity.component(subclassOf: TransformComponent.self)?.location
            entitiesForReset[entity] = position
        }

        let items = try container.decode([ItemJSON].self, forKey: .items)
        for item in items {
            let entity = createItem(fromJson: item)
            entityManager.addEntity(entity)
            let position = entity.component(subclassOf: TransformComponent.self)?.location
            entitiesForReset[entity] = position
        }
    }

    private enum CodingKeys: String, CodingKey {
        case dropSpots
        case items
    }

    private func createItem(fromJson json: ItemJSON) -> Entity {
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

        let spin = SpinComponent(speed: 0.015)
        item.addComponent(spin)

        return item
    }

    private func createDropSpots(fromJson json: DropSpotGoalJSON) -> Entity {
        let dropSpot = Entity()

        let transform = TransformComponent(location: simd_double3(x: Double(json.x), y: 0, z: Double(json.y)))
        dropSpot.addComponent(transform)

        let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1), offset: simd_double3(0, 0.05, 0))
        dropSpot.addComponent(collision)

        let resource = ResourceComponent(resourceIdentifier: json.resourceIdentifier)
        dropSpot.addComponent(resource)

        let inventory = InventoryComponent()
        dropSpot.addComponent(inventory)

        currentInventory[dropSpot] = json.collectiveGoals
        for (type, _) in json.collectiveGoals {
            inventory.add(quantity: 0, ofType: type)
            currentInventory[dropSpot]![type] = 0
        }

        goalInventory[dropSpot] = json.collectiveGoals
        resetInventory = currentInventory

        return dropSpot
    }

    // MARK: - Logic
    override func update(delta: TimeInterval) {
        // Only check if dropspot collides with an item when the player is not holding anything
        if entityManager.player.component(ofType: LinkComponent.self) != nil {
            return
        }

        let dropSpotEntities = entityManager.getEntities(withComponents: CollisionComponent.self, InventoryComponent.self)

        for dropSpot in dropSpotEntities {
            if let dropSpotCollision = dropSpot.component(ofType: CollisionComponent.self) {
                for collectible in collectibles {
                    if let collectibleCollision = collectible.component(ofType: CollisionComponent.self) {
                        if dropSpotCollision.collidesWith(other: collectibleCollision) {
                            addToDropSpotInventory(dropSpot, collectible)
                        }
                    }
                }
            }
        }
    }

    private func addToDropSpotInventory(_ dropSpot: Entity, _ item: Entity) {
        if let quantity = item.component(ofType: QuantityComponent.self),
            let dropSpotInventory = dropSpot.component(ofType: InventoryComponent.self) {

            dropSpotInventory.add(quantity: quantity.quantity, ofType: quantity.type)

            if (currentInventory[dropSpot]?[quantity.type]) != nil {
                currentInventory[dropSpot]?[quantity.type]? += quantity.quantity
                item.removeComponent(ofType: CollisionComponent.self)

                if isComplete() {
                    complete()
                }
            }
            delegate?.levelInfoChanged(self, info: infoLabel)
        }
    }

    override func isComplete() -> Bool {
        if goalInventory.isEmpty {
            return false
        }
        for (entity, dict) in currentInventory {
            for (type, value) in dict {
                var typeGoal = goalInventory[entity]!
                if typeGoal[type] != value {
                    return false
                }
            }
        }

        return true
    }
}

// MARK: - Helpers
private struct DropSpotGoalJSON: Decodable {
    let x: Int
    let y: Int
    let resourceIdentifier: String
    let collectiveGoals: [String: Int]
}

private struct ItemJSON: Decodable {
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
