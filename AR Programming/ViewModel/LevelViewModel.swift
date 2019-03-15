//
//  LevelViewModel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

struct LevelViewModel {
    
    private let modelLoader: EntityModelLoader
    
    let levelModel: Level
    let levelView: SCNNode
    var player: Entity {
        return levelModel.entityManager.player
    }
    
    init(level: Level) {
        levelModel = level
        levelView = SCNNode()
        levelView.scale = SCNVector3(0.05, 0.05, 0.05)
        
        modelLoader = EntityModelLoader(entityManager: level.entityManager, root: levelView)
    }
}
