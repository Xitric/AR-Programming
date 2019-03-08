//
//  Level.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class Level: Equatable, Codable {
    
    let levelType: String
    let name: String
    let levelNumber: Int
    var unlocked = false
    var unlocks: String?
    
    weak var delegate: LevelDelegate?
    
    func reset() {
        delegate?.levelReset(self)
    }
    
    static func == (lhs: Level, rhs: Level) -> Bool {
        return lhs.levelNumber == rhs.levelNumber
    }
    
    //MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        levelType = try container.decode(String.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        levelNumber = try container.decode(Int.self, forKey: .number)
        unlocks = try? container.decode(String.self, forKey: .unlocks)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(levelType, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(levelNumber, forKey: .number)
        try container.encode(unlocks, forKey: .unlocks)
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case number
        case unlocks
    }
    
    //MARK: - Temporary
    init(type: String, name: String, number: Int, unlocks: String?) {
        self.levelType = type
        self.name = name
        self.levelNumber = number
        self.unlocks = unlocks
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
