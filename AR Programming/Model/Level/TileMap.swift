//
//  TileMap.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class TileMap: Codable {
    
    private var collectibles = [[CollectibleState]]()
    
    var collectiblePositions: [(Int, Int)] {
        var positions = [(Int, Int)]()
        
        for y in 0..<collectibles.count {
            for x in 0..<collectibles[y].count {
                if collectibles[y][x] == .uncollected {
                    positions.append((x, y))
                }
            }
        }
        
        return positions
    }
    
    var width: Int {
        return collectibles.count;
    }
    
    var length: Int {
        if (collectibles.count == 0) {
            return 0
        }
        
        return collectibles[0].count;
    }
    
    init(width: Int, height: Int) {
        collectibles = Array(repeating: Array(repeating: .none, count: width), count: height)
    }
    
    func setCollectible(x: Int, y: Int) {
        if ensureBounds(x: x, y: y) {
            collectibles[y][x] = .uncollected
        }
    }
    
    func collectAt(x: Int, y: Int) -> Bool {
        if ensureBounds(x: x, y: y) {
            let didCollectSomething = collectibles[y][x] == .uncollected
            collectibles[y][x] = .collected
            return didCollectSomething
        }
        
        return false
    }
    
    func reset() {
        for y in 0..<collectibles.count {
            for x in 0..<collectibles[y].count {
                if collectibles[y][x] == .collected {
                    collectibles[y][x] = .uncollected
                }
            }
        }
    }
    
    func allCollectiblesTaken() -> Bool {
        return collectiblePositions.count == 0
    }
    
    private func ensureBounds(x: Int, y: Int) -> Bool {
        return y < collectibles.count && y >= 0 && x < collectibles[y].count && x >= 0
    }
    
    private enum CollectibleState: Int, Codable {
        case none
        case uncollected
        case collected
    }
}
