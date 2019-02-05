//
//  AnchoredNode.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import ARKit
import SceneKit

class AnchoredNode: Hashable, Equatable {
    
    var hashValue: Int {
        return node.hashValue
    }
    
    var anchor: ARAnchor
    var node: SCNNode
    
    static func == (lhs: AnchoredNode, rhs: AnchoredNode) -> Bool {
        return lhs.node == rhs.node
    }
    
    init(anchor: ARAnchor, node: SCNNode) {
        self.anchor = anchor
        self.node = node
    }
}
