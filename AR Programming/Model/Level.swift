//
//  Level.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class Level: CardMapper {
    
    var cards: [Int:Card]
    
    init(cards: [Int:Card]) {
        self.cards = cards
    }
    
    func getCard(identifier: Int) -> Card? {
        return cards[identifier]
    }
}
