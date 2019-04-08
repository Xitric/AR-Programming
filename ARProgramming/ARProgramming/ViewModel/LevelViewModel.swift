//
//  LevelViewModel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import EntityComponentSystem

struct LevelViewModel {
    
    private let modelLoader: EntityModelLoader
    
    let levelModel: Level
    let levelView: SCNNode
    var player: Entity {
        return levelModel.entityManager.player
    }
    
    init(level: Level, wardrobe: WardrobeProtocol) {
        levelModel = level
        levelView = SCNNode()
        levelView.scale = SCNVector3(0.15, 0.15, 0.15)
        
        let playerResource = ResourceComponent(resourceIdentifier: wardrobe.selectedRobotSkin())
        levelModel.entityManager.player.addComponent(playerResource)
        
        modelLoader = EntityModelLoader(entityManager: level.entityManager, root: levelView)
    }
}
