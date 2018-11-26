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
    
    var isComplete: Bool {
        return tiles.allCollectiblesTaken()
    }
    
    private init(name: String, levelNumber: Int) {
        self.name = name
        self.levelNumber = levelNumber
        self.cards = [Int:Card]()
        self.tiles = TileMap(width: 0, height: 0)
    }
    
    func getCard(identifier: Int) -> Card? {
        return cards[identifier]
    }
    
    func notifyMovedTo(x: Int, y: Int) {
        tiles.collectAt(x: x, y: y)
    }
    
    // MARK: TODO, level creator
    init(name: String, number: Int) {
        self.name = name
        self.levelNumber = number
        self.cards = [Int:Card]()
        self.tiles = TileMap(width: 0, height: 0)
    }
    
    // MARK: Codable
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let number = try container.decode(Int.self, forKey: CodingKeys.number)
        self.init(name: name, levelNumber: number)
        
        let decodeCards = try container.decode([Int:String].self, forKey: .cards)
        for (index, cardName) in decodeCards {
            cards[index] = CardFactory.instance.getCard(named: cardName)
        }
        
        self.tiles = try container.decode(TileMap.self, forKey: CodingKeys.tiles)
        self.unlocked = try container.decode(Bool.self, forKey: CodingKeys.unlocked)
    }
    
    convenience init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(Level.self, from: json) {
            self.init(name: newValue.name, levelNumber: newValue.levelNumber)
            self.cards = newValue.cards
            self.tiles = newValue.tiles
            self.unlocked = newValue.unlocked
        } else {
            return nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(levelNumber, forKey: CodingKeys.number)
        
        var encodeCards = [Int:String]()
        for (index, card) in cards {
            encodeCards[index] = card.name
        }
        try container.encode(encodeCards, forKey: .cards)
        
        try container.encode(tiles, forKey: CodingKeys.tiles)
        try container.encode(unlocked, forKey: CodingKeys.unlocked)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case number
        case cards
        case tiles
        case unlocked
    }
}
