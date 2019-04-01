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
    let position: simd_double2
    let size: simd_double2
    weak var parent: CardNode?
    
    let number: Int
    
    init(card: ParameterCard, position: simd_double2, size: simd_double2) {
        self.card = card
        self.position = position
        self.size = size
        self.number = card.parameter
    }
    
    convenience init(card: ParameterCard) {
        self.init(card: card, position: simd_double2(0,0), size: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, withParent parent: CardNode?, in graph: ObservationGraph) throws -> CardNode {
        let clone = ParameterCardNode(card: card, position: node.position, size: simd_double2(node.width, node.height))
        return clone
    }
    
    func getCard() -> Card {
        return card
    }
    
    func next() -> CardNode? {
        return nil
    }
}
