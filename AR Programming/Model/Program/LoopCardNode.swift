//
//  LoopCardNode.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import simd

class LoopCardNode: CardNode {
    
    weak var parent: CardNode?
    private let card: StatementCard
    private let successorAngle: Double
    private let parameterCardAngles: [Double]
    
    var successors = [CardNode?]()
    var position: simd_double2
    var repeats: Int?
    
    init(card: StatementCard, angle: Double, position: simd_double2 ) {
        self.card = card
        self.successorAngle = angle
        self.position = position
        self.parameterCardAngles = [Double.pi/2, 3*Double.pi/2]
    }
    
    convenience init(card: StatementCard) {
        self.init(card: card, angle: 0, position: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, in graph: ObservationGraph, withParent parent: CardNode?) throws -> CardNode {
        let clone = LoopCardNode(card: card, angle: 0, position: node.position)
        clone.parent = parent
        try findParameterCards(from: node, clone: clone, graph: graph)
        if let successor = graph.getSuccessor(by: successorAngle, to: node) {
            graph.connect(from: node, to: successor, withAngle: successorAngle)
            clone.successors.append(try CardNodeFactory.instance.cardNode(for: successor, in: graph, parent: clone))
        } else {
            clone.successors.append(nil)
        }
        
        return clone
    }
    
    private func findParameterCards(from node: ObservationNode, clone: LoopCardNode, graph: ObservationGraph) throws {
        for angle in parameterCardAngles {
            if let observedNode = graph.getSuccessor(by: angle, to: node) {
                let cNode = (try CardNodeFactory.instance.cardNode(for: observedNode, in: graph, parent: parent))
                if cNode is ParameterCardNode {
                    let parameterNode = cNode as! ParameterCardNode
                    clone.repeats = parameterNode.number!
                }
            }
        }
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
