//
//  ObservationGraphCardNodeBuilder.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

/// Implementation of the Builder pattern to separate the construction of complex CardNode objects from their representation.
///
/// This will effectively allow for CardNode objects to be constructed in a multitude of ways. As such, CardNode has been completely separated from the notion of ObservationGraph and the ImageAnalysis package.
class ObservationGraphCardNodeBuilder {
    
    private var factory: CardNodeFactory!
    private var graph: ObservationGraph!
    private var node: ObservationNode?
    private var parent: CardNode?
    private var result: CardNode!
    
    func using(factory: CardNodeFactory) -> ObservationGraphCardNodeBuilder {
        self.factory = factory
        return self
    }
    
    func createFrom(graph: ObservationGraph) -> ObservationGraphCardNodeBuilder {
        self.graph = graph
        return self
    }
    
    func using(node: ObservationNode) -> ObservationGraphCardNodeBuilder {
        self.node = node
        return self
    }
    
    func with(parent: CardNode) -> ObservationGraphCardNodeBuilder {
        self.parent = parent
        return self
    }
    
    func getResult() throws -> CardNode {
        guard let node = node ?? graph.firstNode(withPayloadIn: factory.functionDeclarationCodes) else {
            throw CardSequenceError.missingStart
        }
        
        self.node = node
        
        result = try factory.cardNode(withCode: node.payload)
        result.position = node.position
        result.size = simd_double2(node.width, node.height)
        result.parent = parent
        
        if result.card.supportsParameter {
            if let parameter = try findParameter() {
                result.setParameter(parameter)
            } else if result.card.requiresParameter {
                throw CardSequenceError.syntax(message: "This card requires a parameter")
            }
        }
        
        for successor in try findSuccessors(byAngles: result.card.connectionAngles) {
            result.addSuccessor(successor)
        }
        
        try result.link()
        return result
    }
    
    func findParameter() throws -> CardNode? {
        guard let node = node
            else { return nil }
        
        for angle in [Double.pi/2, -Double.pi/2] {
            if let neighbor = graph.getSuccessor(by: angle, to: node) {
                let neighborCard = try factory.cardNode(withCode: neighbor.payload).card
                
                if neighborCard is ParameterCard {
                    graph.connect(from: node, to: neighbor, withAngle: angle)
                    let neighborCardNode = try createChild(fromNode: neighbor)
                    neighborCardNode.entryAngle = angle
                    
                    return neighborCardNode
                }
            }
        }
        
        return nil
    }
    
    func findSuccessors(byAngles angles: [Double]) throws -> [CardNode?] {
        var successors = [CardNode?]()
        guard let node = node
            else { return successors }
        
        for angle in angles {
            if let successor = graph.getSuccessor(by: angle, to: node) {
                
                graph.connect(from: node, to: successor, withAngle: angle)
                let nextCardNode = try createChild(fromNode: successor)
                nextCardNode.entryAngle = angle
                successors.append(nextCardNode)
                
            } else {
                successors.append(nil)
            }
        }
        
        return successors
    }
    
    private func createChild(fromNode nextNode: ObservationNode) throws -> CardNode {
        var builder = ObservationGraphCardNodeBuilder()
            .using(factory: factory)
            .createFrom(graph: graph)
            .using(node: nextNode)
        
        if let result = result {
            builder = builder.with(parent: result)
        }
        
        let child = try builder.getResult()
        try child.link()
        return child
    }
}
