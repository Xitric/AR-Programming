//
//  LoopCardNode.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class LoopCardNode: CardNode {
    
    init() {
        super.init(card: BasicCard(
            internalName: "loop",
            supportsParameter: true,
            requiresParameter: true,
            connectionAngles: [0]))
    }
    
    override func clone() -> CardNode {
        return LoopCardNode()
    }
}
