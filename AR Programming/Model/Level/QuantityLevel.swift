//
//  QuantityLevel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class QuantityLevel: Level {
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("Hello, world!", forKey: .placeholder)
        try super.encode(to: encoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case placeholder
    }
    
    //MARK: - Temporary
    override init(type: String, name: String, number: Int, unlocks: String?) {
        super.init(type: type, name: name, number: number, unlocks: unlocks)
    }
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
