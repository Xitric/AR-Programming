//
//  CardNodeFactory.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

/// Factory for constructing CardNode objects from a code string.
///
/// This class implements the factory pattern to provide a method for constructing CardNode objects. To encapsulate the concrete types of CardNodes constructed, the class further makes use of the prototype pattern.
class CardNodeFactory: CardCollection {

    private var cardNodePrototypes = [String: CardNode]()

    /// An array of codes for cards that define the beginnings of functions.
    let functionDeclarationCodes: [String]

    /// An array of all Cards available for making programs.
    var cards: [Card] {
        return cardNodePrototypes.map {$0.value.card}
    }

    init() {
        functionDeclarationCodes = ["0", "13", "15", "17", "19"]

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

    /// Get a new CardNode instance that represents a card with the specified code.
    ///
    /// This method makes use of the prototype pattern. As such, it will always return a clone of a prototype CardNode. It is safe to mutate this clone in any way.
    ///
    /// - Parameter code: The code of the card to represent.
    /// - Returns: A CardNode instance for a card with the specified code.
    /// - Throws: A CardSequenceError if the code is invalid.
    func cardNode(withCode code: String) throws -> CardNode {
        if let node = cardNodePrototypes[code] {
            return node.clone()
        }

        throw CardSequenceError.unknownCode(code: code)
    }

    /// Register a new prototype CardNode with the specified code.
    ///
    /// - Parameters:
    ///   - node: The prototype CardNode to register.
    ///   - code: The code used to retrieve clones of this prototype later.
    func register(cardNode node: CardNode, withCode code: String) {
        cardNodePrototypes[code] = node
    }

    /// Get the code or payload associated with the specified internal name.
    ///
    /// - Parameter internalName: The internal name of the card to look up, which is assumed to be unique.
    /// - Returns: The code of the card associated with the internal name, or nil if no such card was found
    func cardCode(fromInternalName internalName: String) -> String? {
        for (code, prototype) in cardNodePrototypes where prototype.card.internalName == internalName {
            return code
        }

        return nil
    }
}
