//
//  BorderCardNode.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import simd

class BorderCardNode: CardNode {
    
    private var remainingRepeats: Int!
    private var loopCardNode: LoopCardNode! {
        didSet {
            if let loopCard = loopCardNode {
                remainingRepeats = loopCard.parameter
            }
        }
    }
    
    init() {
        super.init(card: BasicCard(
            internalName: "block",
            supportsParameter: false,
            requiresParameter: false,
            connectionAngles: [0]))
    }
    
    override func create(from node: ObservationNode, withParent parent: CardNode?, in graph: ObservationGraph) throws -> CardNode {
        let clone = try super.create(from: node, withParent: parent, in: graph) as! BorderCardNode
        try clone.findLoop()
        
        return clone
    }
    
    private func findLoop() throws {
        var p = parent
        
        while(p != nil) {
            if let p = p as? LoopCardNode {
                loopCardNode = p
                return
            } else {
                p = p?.parent
            }
        }
        
        //We have reached a card with no parent
        throw CardSequenceError.syntax(message: "Border card is missing a corresponding loop card")
    }
    
    override func clone() -> CardNode {
        return BorderCardNode()
    }
    
    override func next() -> CardNode? {
        remainingRepeats = remainingRepeats - 1
        
        if remainingRepeats > 0 {
            // We iterate back to the loop card
            return loopCardNode.next()
        }
        
        // We are done iterating
        remainingRepeats = loopCardNode.parameter
        if successors.count > 0 {
            return successors[0]
        }
        
        return nil
    }
}
