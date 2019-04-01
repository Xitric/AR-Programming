//
//  ParameterCardNode.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 08/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import simd

class ParameterCardNode: CardNode {
    
    private let card: ParameterCard
    
    let successors: [CardNode?] = [nil]
    var position: simd_double2
    weak var parent: CardNode?
    
    let number: Int
    
    init(card: ParameterCard, position: simd_double2) {
        self.card = card
        self.position = position
        self.number = card.parameter
    }
    
    convenience init(card: ParameterCard) {
        self.init(card: card, position: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, withParent parent: CardNode?, in graph: ObservationGraph) throws -> CardNode {
        let clone = ParameterCardNode(card: card, position: node.position)
        return clone
    }
    
    func getCard() -> Card {
        return card
    }
    
    func next() -> CardNode? {
        return nil
    }
}
