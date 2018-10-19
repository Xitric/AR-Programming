//
//  CardWorld.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class CardWorld {
    
    public var cards : [SCNNode:Card]
    
    init() {
        cards = [SCNNode:Card]()
    }
    
    public func addCard (node: SCNNode, card: Card) {
        cards[node] = card
    }
    
    public func removeCard (node: SCNNode) {
        cards[node] = nil
    }
    
    public func cardFromNode (node: SCNNode) -> Card {
        return cards[node]!
    }
    
    public func allCards () -> [Card] {
        return cards.values.map{$0}
    }
}
