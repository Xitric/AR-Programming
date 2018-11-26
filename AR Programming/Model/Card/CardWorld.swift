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
    
    public var cards = [Plane:Card]()
    
    public func addCard(plane: Plane, card: Card) {
        cards[plane] = card
    }
    
    public func removeCard(plane: Plane) {
        cards[plane] = nil
    }
    
    public func plane(from node: SCNNode) -> Plane? {
        return cards.first(where: { pair -> Bool in
            return pair.key.node == node
        })?.key
    }
    
    public func card(from node: SCNNode) -> Card? {
        if let plane = plane(from: node) {
            return card(from: plane)
        }
        
        return nil
    }
    
    public func card(from plane: Plane) -> Card? {
        return cards[plane]
    }
    
    public func allCards() -> [Card] {
        return cards.values.map{$0}
    }
    
    public func allPlanes() -> [Plane] {
        return cards.keys.map{$0}
    }
    
    public func reset() {
        cards.removeAll()
    }
}
