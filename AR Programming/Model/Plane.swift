//
//  Plane.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class Plane {
    
    let anchor: ARAnchor
    let root: SCNNode
    var groundNode: SCNNode? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromParentNode()
            }
            
            if let groundNode = groundNode {
                root.addChildNode(groundNode)
            }
        }
    }

    init(anchor: ARAnchor) {
        self.anchor = anchor
        self.root = SCNNode()
    }
}
