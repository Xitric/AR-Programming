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
class LevelViewModel: LevelViewModeling, LevelDelegate {
    
    private let wardrobe: WardrobeProtocol
    private let repository: LevelRepository
    private let _level = ObservableProperty<LevelProtocol?>()
    private var modelLoader: EntityModelLoader?
    private let levelView: SCNNode = {
        let node = SCNNode()
        node.scale = SCNVector3(0.15, 0.15, 0.15)
        return node
    }()
    
    //MARK: - State
    var level: ImmutableObservableProperty<LevelProtocol?> {
        return _level
    }
    let complete = ObservableProperty<Bool>(false)
    let levelInfo = ObservableProperty<String?>()
    var player: Entity? {
        return _level.value?.entityManager.player
    }
    
    //MARK: - Init
    init(wardrobe: WardrobeProtocol, levelRepository: LevelRepository) {
        self.wardrobe = wardrobe
        self.repository = levelRepository
    }
    
    func display(level: LevelProtocol?) {
        _level.value = level
        level?.delegate = self
        complete.value = level?.isComplete() ?? false
        levelInfo.value = level?.infoLabel
        
        clearSceneNode()
        
        if let levelModel = _level.value {
            modelLoader = EntityModelLoader(entityManager: levelModel.entityManager,
                                            wardrobe: wardrobe,
                                            root: levelView)
        } else {
            modelLoader = nil
        }
    }
    
    private func clearSceneNode() {
        for child in levelView.childNodes {
            child.removeFromParentNode()
        }
    }
    
    func anchor(at parent: SCNNode?) {
        levelView.removeFromParentNode()
        parent?.addChildNode(levelView)
    }
    
    func addNode(_ node: SCNNode) {
        levelView.addChildNode(node)
    }
    
    func reset() {
        if let levelNumber = _level.value?.levelNumber {
            if let newLevel = try? repository.loadLevel(withNumber: levelNumber) {
                display(level: newLevel)
            }
        }
    }
    
    func goToNext() {
        if let nextLevelNumber = _level.value?.unlocks {
            if let nextLevel = try? repository.loadLevel(withNumber: nextLevelNumber) {
                display(level: nextLevel)
            }
        }
    }
    
    //MARK: - UpdateDelegate
    func update(currentTime: TimeInterval) {
        _level.value?.update(currentTime: currentTime)
    }
    
    //MARK: - LevelDelegate
    func levelCompleted(_ level: LevelProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.complete.value = true
        }
    }
    
    func levelReset(_ level: LevelProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.complete.value = self?._level.value?.isComplete() ?? false
        }
    }
    
    func levelInfoChanged(_ level: LevelProtocol, info: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.levelInfo.value = info
        }
    }
}

protocol LevelViewModeling: UpdateDelegate {
    var level: ImmutableObservableProperty<LevelProtocol?> { get }
    var complete: ObservableProperty<Bool> { get }
    var levelInfo: ObservableProperty<String?> { get }
    var player: Entity? { get }
    
    /// Inform this view model to display the specified level.
    ///
    /// This allows the same view model to be used for various levels. Clients bound to the level property are automatically informed.
    ///
    /// - Parameter level: The level to display.
    func display(level: LevelProtocol?)
    
    /// Inform this view model about where to place the level in the SceneKit or AR scene.
    ///
    /// - Parameter parent: The node to anchor this level to, or nil to remove the level from its current anchor.
    func anchor(at parent: SCNNode?)
    
    /// Add a SCNNode to be displayed as part of this level.
    ///
    /// - Parameter node: The node to add.
    func addNode(_ node: SCNNode)
    
    /// Reset the current level.
    func reset()
    
    /// Load and display the level that follows the currently displayed level.
    func goToNext()
}
