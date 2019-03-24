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
    
    private let startCode: String
    
    private var cardNodePrototypes = [String:CardNode]()
    
    var cards: [Card] {
        return cardNodePrototypes.map{$0.value.getCard()}
    }
    
    private init() {
        startCode = "0"
        
        register(cardNode: SuccessorCardNode(card: StartCard(), angles: [0]), withCode: "0")
        register(cardNode: SuccessorCardNode(card: MoveCard(), angles: [0]), withCode: "1")
        register(cardNode: SuccessorCardNode(card: LeftCard(), angles: [0]), withCode: "2")
        register(cardNode: SuccessorCardNode(card: RightCard(), angles: [0]), withCode: "3")
        register(cardNode: SuccessorCardNode(card: JumpCard(), angles: [0]), withCode: "4")
        register(cardNode: SuccessorCardNode(card: RandomBranchCard(), angles: [Double.pi/4, -Double.pi/4]), withCode: "5")
        register(cardNode: LoopCardNode(), withCode: "6")
        register(cardNode: BorderCardNode(), withCode: "7")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 1)), withCode: "8")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 2)), withCode: "9")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 3)), withCode: "10")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 4)), withCode: "11")
        register(cardNode: SuccessorCardNode(card: PickupCard(), angles: [0]), withCode: "16")
        register(cardNode: SuccessorCardNode(card: DropCard(), angles: [0]), withCode: "17")
    }
    
    
    func build(from graph: ObservationGraph) throws -> CardNode {
        if let startNode = graph.firstNode(withPayload: startCode) {
            return try cardNode(for: startNode, withParent: nil, in: graph)
        }
        
        throw CardSequenceError.missingStart
    }
    
    
    
    func cardNode(for node: ObservationNode, withParent parent: CardNode?, in graph: ObservationGraph) throws -> CardNode {
        if let prototype = try? cardNode(withCode: node.payload) {
            return try prototype.create(from: node, withParent: parent, in: graph)

        }
        
        throw CardSequenceError.unknownCode(code: node.payload)
    }
    
    func cardNode(withCode code: String) throws -> CardNode {
        if let node = cardNodePrototypes[code] {
            return node
        }
        
        throw CardSequenceError.unknownCode(code: code)
    }
    
    func register(cardNode node: CardNode, withCode code: String) {
        cardNodePrototypes[code] = node
    }
}
