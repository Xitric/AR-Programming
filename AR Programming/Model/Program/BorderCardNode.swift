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
    var shouldRepeat: Bool?
    var loopCard: CardNode?
    
    init(card: StatementCard, angle: Double, position: simd_double2 ) {
        self.card = card
        self.successorAngle = angle
        self.position = position
    }
    
    convenience init(card: StatementCard) {
        self.init(card: card, angle: 0, position: simd_double2(0,0))
    }
    
    func create(from node: ObservationNode, in graph: ObservationGraph, withParent parent: CardNode?) throws -> CardNode {
         print("This is the parent: \(String(describing: parent?.getCard().name))")
        let clone = BorderCardNode(card: card, angle: 0, position: node.position)
        clone.parent = parent
        if let successor = graph.getSuccessor(by: successorAngle, to: node) {
            graph.connect(from: node, to: successor, withAngle: successorAngle)
                  clone.successors.append(try CardNodeFactory.instance.cardNode(for: successor, in: graph, parent: clone))
        } else {
            clone.successors.append(nil)
        }
        clone.loopCard = findLoopCard(in: graph, with: parent)
//        clone.shouldRepeat = true
        return clone
    }

    func findLoopCard(in graph: ObservationGraph, with parent: CardNode?) -> CardNode? {
        var p = parent
        
        while(p != nil){
            if p?.getCard() is LoopCard{
//                let loopCardNode = p as! LoopCardNode
//                shouldRepeat = loopCardNode.
//                self.shouldRepeat = true
                return p
            } else {
                p = p?.parent
            }
        }
        // It will return nil if no loop card is found
        return p
    }
    
    func getCard() -> Card {
        return card
    }
    
    func next() -> CardNode? {
       
        if !(parent?.getCard() is LoopCard) {
            if let loopCard = loopCard{
                return loopCard.successors[0]
            }
        }
        let branch = card.getContinuationIndex()
        if branch >= 0 && branch < successors.count {
            return successors[branch]
        }
        
        return nil
    }
}
