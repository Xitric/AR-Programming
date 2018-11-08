//
//  TileMap.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 08/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class TileMap: Codable {
    
    private var collectibles = [[Bool]]()
    
    var collectiblePositions: [Vector2] {
        var positions = [Vector2]()
        
        for y in 0..<collectibles.count {
            for x in 0..<collectibles[y].count {
                if collectibles[y][x] {
                    positions.append(Vector2(x: Float(x), y: Float(y)))
                }
            }
        }
        
        return positions
    }
    
    init(width: Int, height: Int) {
        collectibles = Array(repeating: Array(repeating: false, count: width), count: height)
    }
    
    func setCollectible(x: Int, y: Int) {
        if ensureBounds(x: x, y: y) {
            collectibles[y][x] = true
        }
    }
    
    func collectAt(x: Int, y: Int) {
        if ensureBounds(x: x, y: y) {
            collectibles[y][x] = false
        }
    }
    
    func allCollectiblesTaken() -> Bool {
        return collectiblePositions.count == 0
    }
    
    private func ensureBounds(x: Int, y: Int) -> Bool {
        return y < collectibles.count && y >= 0 && x < collectibles[y].count && x >= 0
    }
}
