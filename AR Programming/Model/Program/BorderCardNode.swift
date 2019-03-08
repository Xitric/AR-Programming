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
    
    weak var parent: CardNode?
    private let card: StatementCard
    private var successorAngle: Double
    
    var successors = [CardNode?]()
    var position: simd_double2    
    var repeats: Int?
    var loopCardNode: LoopCardNode? {
        didSet {
            if let loopCard = loopCardNode{
                repeats = loopCard.repeats
            }
        }
    }
    
    init(card: StatementCard, angle: Double, position: simd_double2 ) {
        self.card = card
        self.successorAngle = angle
        self.position = position
    }
    
    convenience init(card: StatementCard) {
        self.init(card: card, angle: 0, position: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, in graph: ObservationGraph, withParent parent: CardNode?) throws -> CardNode {
        let clone = BorderCardNode(card: card, angle: 0, position: node.position)
        clone.parent = parent
        if let successor = graph.getSuccessor(by: successorAngle, to: node) {
            graph.connect(from: node, to: successor, withAngle: successorAngle)
            clone.successors.append(try CardNodeFactory.instance.cardNode(for: successor, in: graph, parent: clone))
        } else {
            clone.successors.append(nil)
        }
        clone.loopCardNode = findLoopCard(in: graph, with: parent)
        return clone
    }
    
    func findLoopCard(in graph: ObservationGraph, with parent: CardNode?) -> LoopCardNode? {
        var p = parent
        
        while(p != nil){
            if p?.getCard() is LoopCard{
                return p as? LoopCardNode
            } else {
                p = p?.parent
            }
        }
        // We will reach the start card if there is no loop card
        return nil
    }
    
    func getCard() -> Card {
        return card
    }
    
    func next() -> CardNode? {
        if !(parent?.getCard() is LoopCard) {
            if let loopCard = loopCardNode{
                if loopCard.repeats != nil {
                    if loopCard.repeats != 1 {
                        loopCard.repeats = loopCard.repeats! - 1
                        return loopCard.successors[0]
                    }
                    loopCard.repeats = repeats
                }
            }
        }
        
        let branch = card.getContinuationIndex()
        if branch >= 0 && branch < successors.count {
            return successors[branch]
        }
        
        return nil
    }
}
