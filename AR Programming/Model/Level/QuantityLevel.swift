//
//  QuantityLevel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class QuantityLevel: Level {
    
    func update(_ delta: TimeInterval) {
        
    }
    
    func isComplete() -> Bool {
        return false
    }
    
    func getScore() -> Int {
        return 0
    }
    
    func reset() {
        delegate?.levelReset(self)
    }
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let collectibles = try? container.decode([CollectibleJSON].self, forKey: .collectibles)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
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
