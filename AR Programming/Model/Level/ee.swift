//
//  CleanUpLevel.swift
//  AR Programming
//
//  Created by Emil Nielsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ee: Level {
    
    private var dropOffGoals = [String:simd_double2]()
    
    private var items: [Entity] {
        get {
            return entityManager.getEntities(withComponents: CollectibleComponent.self)
        }
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dropOffs = try container.decode([DropOffGoalJSON].self, forKey: CodingKeys.dropOffs)
        save(dropOffGoals: dropOffs, into: &dropOffGoals)
        
        let items = try container.decode([ItemJson].self, forKey: CodingKeys.items)
        for item in items {
            let entity = createItem(fromJson: item)
            entityManager.addEntity(entity)
            // for Reset?
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case dropOffs
        case items
    }
    
    private func save(dropOffGoals: [DropOffGoalJSON], into dictionary: inout [String:simd_double2]) {
        for dropOff in dropOffGoals {
            dictionary[dropOff.type] = vector2(Double(dropOff.x), Double(dropOff.y))
        }
    }
    
    private func createItem(fromJson itemjson: ItemJson) -> Entity {
        let item = Entity()
        
        let collectible = CollectibleComponent()
        item.addComponent(collectible)
        
        let transform = TransformComponent(location: simd_double3(x: Double(itemjson.x), y: 0, z: Double(itemjson.y)))
        item.addComponent(transform)
        
        let collision = CollisionComponent(size: simd_double3(0.1, 0.1, 0.1), offset: simd_double3(0, 0.05, 0))
        item.addComponent(collision)
        
        let resource = ResourceComponent(resourceIdentifier: itemjson.resourceIdentifier)
        item.addComponent(resource)
        
        return item
    }
    
    
}

private struct DropOffGoalJSON: Decodable {
    let type: String
    let x: Int
    let y: Int
}

private struct ItemJson: Decodable {
    let type: String
    let x: Int
    let y: Int
    let resourceIdentifier: String
}

// MARK: - LevelFactory
class eeee: LevelFactory {
    
    func canReadLevel(ofType levelType: String) -> Bool {
        return "testtype" == levelType
    }
    
    func initLevel(json: Data) throws -> Level {
        return try JSONDecoder().decode(CleanUpLevel.self, from: json)
    }
}
