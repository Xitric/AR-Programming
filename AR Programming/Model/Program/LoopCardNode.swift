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
    
    private let successorAngle = 0.0
    private let parameterCardAngles = [Double.pi/2, -Double.pi/2]
    
    var successors = [CardNode?]()
    let position: simd_double2
    let size: simd_double2
    weak var parent: CardNode?
    
    var repeats: Int!
    
    init(position: simd_double2, size: simd_double2) {
        self.position = position
        self.size = size
    }
    
    convenience init() {
        self.init(position: simd_double2(0,0), size: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, withParent parent: CardNode?, in graph: ObservationGraph) throws -> CardNode {
        let clone = LoopCardNode(position: node.position, size: simd_double2(node.width, node.height))
        clone.parent = parent
        
        try findParameterCards(from: node, clone: clone, graph: graph)
        
        if let successor = graph.getSuccessor(by: successorAngle, to: node) {
            graph.connect(from: node, to: successor, withAngle: successorAngle)
            clone.successors.append(try CardNodeFactory.instance.cardNode(for: successor, withParent: clone, in: graph))
        } else {
            clone.successors.append(nil)
        }
        
        return clone
    }
    
    private func findParameterCards(from node: ObservationNode, clone: LoopCardNode, graph: ObservationGraph) throws {
        for angle in parameterCardAngles {
            if let observedNode = graph.getSuccessor(by: angle, to: node) {
                let cNode = (try CardNodeFactory.instance.cardNode(for: observedNode, withParent: self, in: graph))
                if let parameterNode = cNode as? ParameterCardNode {
                    clone.repeats = parameterNode.number
                    return
                }
            }
        }
        
        throw CardSequenceError.syntax(message: "Loop card is missing a parameter")
    }
    
    func getCard() -> Card {
        return LoopCard()
    }
    
    func next() -> CardNode? {
        if successors.count > 0 {
            return successors[0]
        }
        
        return nil
    }
}
