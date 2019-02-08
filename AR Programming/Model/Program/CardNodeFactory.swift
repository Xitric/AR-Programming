//
//  CardNodeFactory.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CardNodeFactory {
    
    static var instance = CardNodeFactory()
    
    private let startCode: Int
    private var nodePrototypes = [Int:CardNode]()
    
    var cards: [Card] {
        return nodePrototypes.map{$0.value.getCard()}
    }
    
    private init() {
        startCode = 0
        
        register(cardNode: SuccessorCardNode(card: StartCard(), angles: [0]), with: 0)
        register(cardNode: SuccessorCardNode(card: MoveCard(), angles: [0]), with: 1)
        register(cardNode: SuccessorCardNode(card: LeftCard(), angles: [0]), with: 2)
        register(cardNode: SuccessorCardNode(card: RightCard(), angles: [0]), with: 3)
        register(cardNode: SuccessorCardNode(card: JumpCard(), angles: [0]), with: 4)
        register(cardNode: SuccessorCardNode(card: RandomBranchCard(), angles: [0.785, -0.785]), with: 5)
    }
    
    func build(from graph: ObservationGraph) throws -> CardNode {
        if let startObservation = graph.firstObservation(with: startCode) {
            return try node(for: startObservation, in: graph)
        }
        
        throw CardSequenceError.missingStart
    }
    
    func node(for observation: ObservationNode, in graph: ObservationGraph) throws -> CardNode {
        if let prototype = nodePrototypes[observation.code] {
            return try prototype.create(from: observation, in: graph)
        }
        
        throw CardSequenceError.unknownCode(code: observation.code)
    }
    
    func register(cardNode node: CardNode, with code: Int) {
        nodePrototypes[code] = node
    }
}
