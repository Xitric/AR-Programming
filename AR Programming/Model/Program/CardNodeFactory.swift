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
        register(cardNode: LoopCardNode(card: LoopCard()), withCode: "6")
        register(cardNode: BorderCardNode(card: BorderCard()), withCode: "7")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 1)), withCode: "8")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 2)), withCode: "9")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 3)), withCode: "10")
        register(cardNode: ParameterCardNode(card: ParameterCard(paremeter: 4)), withCode: "11")
    }
    
    
    func build(from graph: ObservationGraph) throws -> CardNode {
        if let startNode = graph.firstNode(withPayload: startCode) {
            return try cardNode(for: startNode, in: graph, parent: nil)
        }
        
        throw CardSequenceError.missingStart
    }
    
    
    
    func cardNode(for node: ObservationNode, in graph: ObservationGraph, parent: CardNode?) throws -> CardNode {
        if let prototype = try? getCardNode(withCode: node.payload) {
            return try prototype.create(from: node, in: graph, withParent: parent)

        }
        
        throw CardSequenceError.unknownCode(code: node.payload)
    }
    
    func getCardNode(withCode code: String) throws -> CardNode {
        if let node = cardNodePrototypes[code] {
            return node
        }
        
        throw CardSequenceError.unknownCode(code: code)
    }
    
    func register(cardNode node: CardNode, withCode code: String) {
        cardNodePrototypes[code] = node
    }
}
