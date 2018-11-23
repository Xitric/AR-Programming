//
//  PlayingField.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import SceneKit

struct PlayingField {
    
    var origo: AnchoredNode
    var ground: Plane
    var robot: AnimatableNode
    var collectibles: [SCNNode]
    
    mutating func addCollectible(node: SCNNode) {
        origo.node.addChildNode(node)
        collectibles.append(node)
    }
    
    mutating func removeCollectible(at position: Vector2) {
        for node in collectibles {
            let dx = node.position.x - position.x
            let dy = node.position.z - position.y
            
            if (abs(dx * dx - dy * dy) < 0.0000000001) {
                node.removeFromParentNode()
                collectibles.remove(at: collectibles.firstIndex(of: node)!)
                break
            }
        }
    }
    
    mutating func clearCollectibles() {
        for node in collectibles {
            node.removeFromParentNode()
            collectibles.remove(at: collectibles.firstIndex(of: node)!)
        }
    }
}
