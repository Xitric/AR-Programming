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
import Level

/// A layer of abstraction built on top of the Level model to automatically manage its graphical representation in the UI.
///
/// This view model will synchronize the state of the Level model with a SceneKit representation. It is allso possible to bind to this view model to be notified of any changes to the selected Level.
class LevelViewModel: UpdateDelegate {
    
    private let wardrobe: WardrobeProtocol
    private var modelLoader: EntityModelLoader?
    private var levelView: SCNNode?
    
    //MARK: - State
    var levelModel: LevelProtocol? {
        didSet {
            levelView = SCNNode()
            levelView?.scale = SCNVector3(0.15, 0.15, 0.15)
            
            if let levelModel = levelModel {
                modelLoader = EntityModelLoader(entityManager: levelModel.entityManager,
                                                wardrobe: wardrobe,
                                                root: levelView!)
            }
            
            //Inform binding of state change
            levelChanged?()
        }
    }
    var player: Entity? {
        return levelModel?.entityManager.player
    }
    
    //MARK: - Bindings
    var levelChanged: (() -> Void)?
    
    //MARK: - Init
    init(wardrobe: WardrobeProtocol) {
        self.wardrobe = wardrobe
    }
    
    //MARK: - UpdateDelegate
    func update(currentTime: TimeInterval) {
        levelModel?.update(currentTime: currentTime)
    }
    
    /// Inform this view model about where to place the level in the SceneKit or AR scene.
    ///
    /// - Parameter parent: The node to anchor this level to, or nil to remove the level from its current anchor.
    func anchor(at parent: SCNNode?) {
        if let levelView = levelView {
            levelView.removeFromParentNode()
            parent?.addChildNode(levelView)
        }
    }
    
    /// Add a SCNNode to be displayed as part of this level.
    ///
    /// - Parameter node: The node to add.
    func addNode(_ node: SCNNode) {
        if let levelView = levelView {
            levelView.addChildNode(node)
        }
    }
}
