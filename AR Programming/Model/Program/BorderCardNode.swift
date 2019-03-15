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
    
    private let successorAngle = 0.0
    
    var successors = [CardNode?]()
    var position: simd_double2
    weak var parent: CardNode?
    
    var repeats: Int!
    var loopCardNode: LoopCardNode? {
        didSet {
            if let loopCard = loopCardNode {
                repeats = loopCard.repeats
            }
        }
    }
    
    init(position: simd_double2) {
        self.position = position
    }
    
    convenience init() {
        self.init(position: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, withParent parent: CardNode?, in graph: ObservationGraph) throws -> CardNode {
        let clone = BorderCardNode(position: node.position)
        clone.parent = parent
        if let successor = graph.getSuccessor(by: successorAngle, to: node) {
            graph.connect(from: node, to: successor, withAngle: successorAngle)
            clone.successors.append(try CardNodeFactory.instance.cardNode(for: successor, withParent: clone, in: graph))
        } else {
            clone.successors.append(nil)
        }
        clone.loopCardNode = try clone.findLoopCard(in: graph)
        return clone
    }
    
    func findLoopCard(in graph: ObservationGraph) throws -> LoopCardNode {
        var p = parent
        
        while(p != nil){
            if let p = p as? LoopCardNode {
                return p
            } else {
                p = p?.parent
            }
        }
        //We have reached a card with no parent
        throw CardSequenceError.syntax(message: "Border card is missing a corresponding loop card")
    }
    
    func getCard() -> Card {
        return BorderCard()
    }
    
    func next() -> CardNode? {
        if let loopCard = loopCardNode {
            if loopCard.repeats != 1 {
                loopCard.repeats = loopCard.repeats - 1
                return loopCard.next()
            }
            loopCard.repeats = repeats
        }
        
        if successors.count > 0 {
            return successors[0]
        }
        
        return nil
    }
}
