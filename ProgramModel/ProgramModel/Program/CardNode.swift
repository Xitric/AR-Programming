//
//  CardNode.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

public class CardNode {
    
    public private(set) var position = simd_double2(0, 0)
    public private(set) var size = simd_double2(0, 0)
    public private(set) var entryAngle = 0.0
    public private(set) var children = [CardNode]()
    public let card: Card
    private(set) var successors = [CardNode?]()
    
    weak var parent: CardNode?
    var parameter: Int?
    
    init(card: Card) {
        self.card = card
    }
    
    func create(from node: ObservationNode, withParent parent: CardNode?, in graph: ObservationGraph) throws -> CardNode {
        let clone = self.clone()
        clone.position = node.position
        clone.size = simd_double2(node.width, node.height)
        clone.parent = parent
        
        if (card.supportsParameter) {
            try clone.findParameter(to: node, in: graph)
        }
        try clone.findSuccessors(to: node, in: graph)
        
        return clone
    }
    
    func findSuccessors(to node: ObservationNode, in graph: ObservationGraph) throws {
        for angle in card.connectionAngles {
            if let successor = graph.getSuccessor(by: angle, to: node) {
                
                graph.connect(from: node, to: successor, withAngle: angle)
                let nextCardNode = try CardNodeFactory.instance.cardNode(for: successor, withParent: self, in: graph)
                nextCardNode.entryAngle = angle
                addSuccessor(successor: nextCardNode)
                
            } else {
                self.successors.append(nil)
            }
        }
    }
    
    func findParameter(to node: ObservationNode, in graph: ObservationGraph) throws {
        for angle in [Double.pi/2, -Double.pi/2] {
            if let neighbor = graph.getSuccessor(by: angle, to: node) {
                let neighborCard = try CardNodeFactory.instance.cardNode(withCode: neighbor.payload).card
                
                if let parameterCard = neighborCard as? ParameterCard {
                    graph.connect(from: node, to: neighbor, withAngle: angle)
                    let nextCardNode = try CardNodeFactory.instance.cardNode(for: neighbor, withParent: self, in: graph)
                    parameter = parameterCard.parameter
                    nextCardNode.entryAngle = angle
                    self.children.append(nextCardNode)
                    
                    return
                }
            }
        }
        
        if card.requiresParameter {
            throw CardSequenceError.syntax(message: "This card requires a parameter")
        }
    }
    
    func addSuccessor(successor: CardNode) {
        children.append(successor)
        successors.append(successor)
    }
    
    func clone() -> CardNode {
        return CardNode(card: card)
    }
    
    func getAction(forEntity entity: Entity, withProgramState state: ProgramState) -> Action? {
        return nil
    }
    
    func next() -> CardNode? {
        if successors.count > 0 {
            return successors[0]
        }
        
        return nil
    }
}
