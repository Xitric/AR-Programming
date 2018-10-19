//
//  AnchoredNode.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import ARKit
import SceneKit

class AnchoredNode {
    
    var anchor: ARAnchor
    var node: SCNNode
    
    init(anchor: ARAnchor, node: SCNNode) {
        self.anchor = anchor
        self.node = node
    }
}
