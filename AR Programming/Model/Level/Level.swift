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
    var cards: [Int:Card]
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        self.init(name: name)
        
        let decodeCards = try container.decode([Int:String].self, forKey: .cards)
        for (index, cardName) in decodeCards {
            cards[index] = CardFactory.instance.getCard(named: cardName)
        }
    }
    
    convenience init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(Level.self, from: json) {
            self.init(name: newValue.name)
            self.cards = newValue.cards
        } else {
            return nil
        }
    }
    
    private init(name: String) {
        self.name = name
        self.cards = [Int:Card]()
    }
    
    //TODO: Start
    init() {
        name = "Level 1"
        cards = [Int:Card]()
        cards[0] = CardFactory.instance.getCard(named: "move")
        cards[1] = CardFactory.instance.getCard(named: "move")
        cards[2] = CardFactory.instance.getCard(named: "left")
        cards[3] = CardFactory.instance.getCard(named: "right")
    }
    //TODO: End
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        
        var encodeCards = [Int:String]()
        for (index, card) in cards {
            encodeCards[index] = card.name
        }
        try container.encode(encodeCards, forKey: .cards)
    }
    
    func getCard(identifier: Int) -> Card? {
        return cards[identifier]
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case cards
    }
}
