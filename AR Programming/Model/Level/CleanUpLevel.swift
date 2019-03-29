//
//  CleanUpLevel.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CleanUpLevel: Level {
    
    private var dropOffGoals = [String:simd_double3]()
    private var dropOffAmounts = [String:Int]()
    
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
        save(goals: dropOffs)
        
        let items = try container.decode([IemJSON].self, forKey: .items)
        for item in items {
            let entity = createItem(fromJson: item)
            entityManager.addEntity(entity)
            collectiblesForReset.append(entity)
        }
        
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case dropOffs
        case items
    }
    
    private func save(goals: [DropOffGoalJSON]) {
        var position = [String:simd_double3]()
      //  var amounts = [String:Int]()
        for dropOff in goals {
            position[dropOff.type] = vector3(Double(dropOff.x), 0, Double(dropOff.y))
        //    amounts[dropOff.type] = dropOff.amounts
        }
        dropOffGoals = position
      //  dropOffAmounts = amounts
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
        
        return item
    }
    
    
    //MARK: - Logic
    override func update(delta: TimeInterval) {
        if isComplete() {
            complete()
        }
    }
    
    override func isComplete() -> Bool {
        for entity in collectibles {
            guard let currentPosition = entity.component(subclassOf: TransformComponent.self)?.location else { return false }
            for (_, position) in dropOffGoals {
                if !simd_double3.vectEqual(currentPosition, position, tolerance: 0.1){
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
  //  let amounts: Int
}

private struct IemJSON: Decodable {
    let type: String
    let x: Int
    let y: Int
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
