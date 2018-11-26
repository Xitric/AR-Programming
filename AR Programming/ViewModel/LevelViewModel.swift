//
//  LevelViewModel.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 26/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class LevelViewModel {
    
    private static let coordinateScale = Float(0.05)
    
    private let playingField: PlayingField
    private let levelWidth: Int
    private var collectibles = [Int:SCNNode]()
    
    init(showing field: PlayingField, withLevelWidth width: Int) {
        playingField = field;
        levelWidth = width
    }
    
    func addCollectible(node: SCNNode, x: Int, y: Int) {
        node.position = SCNVector3()
        
        node.position.x = Float(x) * LevelViewModel.coordinateScale
        node.position.z = Float(y) * LevelViewModel.coordinateScale
        playingField.origo.node.addChildNode(node)
        
        let i = coordinatesToIndex(x: x, y: y)
        
        collectibles[i] = node
    }
    
    private func coordinatesToIndex(x: Int, y: Int) -> Int {
        return x + y * levelWidth
    }
    
    func removeCollectible(x: Int, y: Int) {
        let i = coordinatesToIndex(x: x, y: y)
        collectibles[i]?.removeFromParentNode()
        collectibles[i] = nil
    }
    
    func clearCollectibles() {
        for (_, node) in collectibles {
            node.removeFromParentNode()
        }
        
        collectibles.removeAll()
    }
}
