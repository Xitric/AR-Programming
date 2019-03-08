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
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        goalQuantity = try container.decode(Int.self, forKey: .goalQuantity)
        try super.init(from: decoder)
        
        let collectibles = try container.decode([CollectibleJSON].self, forKey: .collectibles)
        for collectible in collectibles {
            entityManager.addEntity(createCollectible(fromJson: collectible))
        }
    }
    
    private func createCollectible(fromJson json: CollectibleJSON) -> Entity {
        let collectible = Entity()
        
        let transform = TransformComponent()
        transform.location = simd_double3(x: Double(json.x) * 0.05, y: 0, z: Double(json.y) * 0.05)
        collectible.addComponent(transform)
        
        let quantity = QuantityComponent(quantity: json.quantity)
        collectible.addComponent(quantity)
        
        let resource = ResourceComponent(resourceIdentifier: "TODO")
        collectible.addComponent(resource)
        
        return collectible
    }
    
    private enum CodingKeys: String, CodingKey {
        case goalQuantity
        case collectibles
    }
}

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
