//
//  CardNode.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

/// A representation of a statement in a program sequence.
public class CardNode {
    
    public internal(set) var position = simd_double2(0, 0)
    public internal(set) var size = simd_double2(0, 0)
    public internal(set) var entryAngle = 0.0
    public private(set) var children = [CardNode]()
    private(set) var successors = [CardNode?]()
    public let card: Card
    
    weak var parent: CardNode?
    var parameter: Int?
    
    init(card: Card) {
        self.card = card
    }
    
    func clone() -> CardNode {
        return CardNode(card: card)
    }
    
    func addSuccessor(_ successor: CardNode?) {
        successors.append(successor)
        
        if let successor = successor {
            children.append(successor)
        }
    }
    
    func setParameter(_ parameterNode: CardNode) {
        if let parameterCard = parameterNode.card as? ParameterCard {
            parameter = parameterCard.parameter
            children.append(parameterNode)
        }
    }
    
    /// Overridable by subclasses to perform any linking after the CardNode composite has been constructed.
    ///
    /// - Throws: A CardSequenceError if the linking operation failed.
    func link() throws { }
    
    /// Get the action to be performed when executing this program statement, if any.
    ///
    /// - Parameters:
    ///   - entity: The entity on which the program is running.
    ///   - state: The complete state representation of the running program.
    /// - Returns: The action to be performed, or nil if this statement specifies no action.
    func getAction(forEntity entity: Entity, withProgramState state: ProgramState) -> Action? {
        return nil
    }
    
    /// Get the next statement in the program.
    ///
    /// - Returns: The next statement in the program, or nil if this statement is the last.
    func next() -> CardNode? {
        if successors.count > 0 {
            return successors[0]
        }
        
        return nil
    }
}
