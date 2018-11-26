//
//  Level.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class Level: CardMapper, Codable {
    
    let name: String
    let levelNumber: Int
    var tiles: TileMap
    var cards: [Int:Card]
    var unlocked = false
    var unlocks: String?
    
    public weak var delegate: LevelDelegate?
    public var collectiblePositions: [(Int, Int)] {
        return tiles.collectiblePositions
    }
    
    var width: Int {
        return tiles.width
    }
    
    var length: Int {
        return tiles.length
    }
    
    private init(name: String, levelNumber: Int, unlocks: String?) {
        self.name = name
        self.levelNumber = levelNumber
        self.cards = [Int:Card]()
        self.tiles = TileMap(width: 0, height: 0)
        self.unlocks = unlocks
    }
    
    func getCard(identifier: Int) -> Card? {
        return cards[identifier]
    }
    
    func notifyMovedTo(x: Int, y: Int) {
        if tiles.collectAt(x: x, y: y) {
            delegate?.collectibleTaken(self, x: x, y: y)
            
            if tiles.allCollectiblesTaken() {
                if let levelToUnlock = unlocks {
                    LevelManager.markLevel(withName: levelToUnlock, asUnlocked: true)
                }
                delegate?.levelCompleted(self)
            }
        }
    }
    
    func reset() {
        tiles.reset()
        delegate?.levelReset(self)
    }
    
    // MARK: TODO, level creator
    convenience init(name: String, number: Int, unlocks: String?) {
        self.init(name: name, levelNumber: number, unlocks: unlocks)
    }
    
    // MARK: Codable
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let number = try container.decode(Int.self, forKey: CodingKeys.number)
        let unlocks = try? container.decode(String.self, forKey: CodingKeys.unlocks)
        self.init(name: name, levelNumber: number, unlocks: unlocks)
        
        let decodeCards = try container.decode([Int:String].self, forKey: .cards)
        for (index, cardName) in decodeCards {
            cards[index] = CardFactory.instance.getCard(named: cardName)
        }
        
        self.tiles = try container.decode(TileMap.self, forKey: CodingKeys.tiles)
    }
    
    convenience init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(Level.self, from: json) {
            self.init(name: newValue.name, levelNumber: newValue.levelNumber, unlocks: newValue.unlocks)
            self.cards = newValue.cards
            self.tiles = newValue.tiles
        } else {
            return nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(levelNumber, forKey: CodingKeys.number)
        try container.encode(unlocks, forKey: CodingKeys.unlocks)
        
        var encodeCards = [Int:String]()
        for (index, card) in cards {
            encodeCards[index] = card.name
        }
        try container.encode(encodeCards, forKey: .cards)
        
        try container.encode(tiles, forKey: CodingKeys.tiles)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case number
        case cards
        case tiles
        case unlocks
    }
}
