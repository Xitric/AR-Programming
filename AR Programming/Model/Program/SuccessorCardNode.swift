//
//  MultiSuccessorCardNode.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import simd

class SuccessorCardNode: CardNode {
    
    private let card: StatementCard
    private let successorAngles: [Double]
    
    var successors = [CardNode?]()
    var position: simd_double2
    
    init(card: StatementCard, angles: [Double], position: simd_double2) {
        self.card = card
        self.successorAngles = angles
        self.position = position
    }
    
    convenience init(card: StatementCard, angles: [Double]) {
        self.init(card: card, angles: angles, position: simd_double2(0, 0))
    }
    
    func create(from node: ObservationNode, in graph: ObservationGraph) throws -> CardNode {
        let clone = SuccessorCardNode(card: card, angles: successorAngles, position: node.position)
        
        for angle in successorAngles {
            if let next = graph.getSuccessor(by: angle, to: node) {
                graph.connect(from: node, to: next, with: angle)
                clone.successors.append(try CardNodeFactory.instance.node(for: next, in: graph))
            } else {
                clone.successors.append(nil)
            }
        }
        
        return clone
    }
    
    func getCard() -> Card {
        return card
    }
    
    func next() -> CardNode? {
        let branch = card.getContinuationIndex()
        
        if branch >= 0 && branch < successors.count {
            return successors[branch]
        }
        
        return nil
    }
}
