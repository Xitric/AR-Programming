//
//  CardSequence.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CardSequence {
    
    private var sequence = [Card]()
    
    init(sequence: [Card]) {
        self.sequence = sequence
    }
    
    public func run(on node: AnimatableNode) {
        for card in sequence {
            card.command?.execute(modelIn3D: node)
        }
    }
}
