//
//  NumberCardNode.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 08/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import simd

class NumberCardNode: CardNode {
    
    var successors = [CardNode?]()
    
    var parent: CardNode?
    
    private let card: StatementCard
    var position: simd_double2
    var number: Int?
    
    init(card: StatementCard, position: simd_double2) {
        self.card = card
        self.position = position
        self.number = (getCard() as! ParameterCard).parameter
    }
    
    convenience init(card: StatementCard) {
        self.init(card: card, position: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, in graph: ObservationGraph, withParent parent: CardNode?) throws -> CardNode {
        let clone = NumberCardNode(card: card, position: node.position)
        return clone
    }
    
    func getCard() -> Card {
        return card
    }
    
    func next() -> CardNode? {
        return nil
    }
}
