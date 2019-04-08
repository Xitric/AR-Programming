//
//  CardNodeFactory.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public class CardNodeFactory {
    
    public static var instance = CardNodeFactory()
    
    private let startCodes: [String]
    
    private var cardNodePrototypes = [String:CardNode]()
    
    public var cards: [Card] {
        return cardNodePrototypes.map{$0.value.card}
    }
    
    private init() {
        startCodes = ["0", "13", "15", "17", "19"]
        
        // Control
        register(cardNode: FunctionCardNode(functionNumber: 0, isCaller: false), withCode: "0")
        register(cardNode: FunctionCardNode(functionNumber: 1, isCaller: true), withCode: "12")
        register(cardNode: FunctionCardNode(functionNumber: 1, isCaller: false), withCode: "13")
        register(cardNode: FunctionCardNode(functionNumber: 2, isCaller: true), withCode: "14")
        register(cardNode: FunctionCardNode(functionNumber: 2, isCaller: false), withCode: "15")
        register(cardNode: FunctionCardNode(functionNumber: 3, isCaller: true), withCode: "16")
        register(cardNode: FunctionCardNode(functionNumber: 3, isCaller: false), withCode: "17")
        register(cardNode: FunctionCardNode(functionNumber: 4, isCaller: true), withCode: "18")
        register(cardNode: FunctionCardNode(functionNumber: 4, isCaller: false), withCode: "19")
        
        // Loop
        register(cardNode: LoopCardNode(), withCode: "6")
        register(cardNode: BorderCardNode(), withCode: "7")
        
        // Actions
        register(cardNode: SimpleActionCardNode(name: "move", action: MoveAction()), withCode: "1")
        register(cardNode: SimpleActionCardNode(name: "left", action: RotationAction(direction: .left)), withCode: "2")
        register(cardNode: SimpleActionCardNode(name: "right", action: RotationAction(direction: .right)), withCode: "3")
        register(cardNode: SimpleActionCardNode(name: "jump", action: JumpAction()), withCode: "4")
        register(cardNode: SimpleActionCardNode(name: "pickup", action: PickupAction()), withCode: "20")
        register(cardNode: SimpleActionCardNode(name: "drop", action: DropAction()), withCode: "21")
        
        // Parameters
        register(cardNode: CardNode(card: ParameterCard(parameter: 1)), withCode: "8")
        register(cardNode: CardNode(card: ParameterCard(parameter: 2)), withCode: "9")
        register(cardNode: CardNode(card: ParameterCard(parameter: 3)), withCode: "10")
        register(cardNode: CardNode(card: ParameterCard(parameter: 4)), withCode: "11")
    }
    
    
    func build(from graph: ObservationGraph) throws -> CardNode {
        if let startNode = graph.firstNode(withPayloadIn: startCodes) {
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
