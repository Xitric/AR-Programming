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
    private let _level = ObservableProperty<LevelProtocol?>()
    private var modelLoader: EntityModelLoader?
    private var levelView: SCNNode?
    
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
    init(wardrobe: WardrobeProtocol) {
        self.wardrobe = wardrobe
    }
    
    func display(level: LevelProtocol?) {
        _level.value = level
        level?.delegate = self
        
        complete.value = level?.isComplete() ?? false
        levelInfo.value = level?.infoLabel
        
        //TODO: Repopulate existing scene node!
        levelView = SCNNode()
        levelView?.scale = SCNVector3(0.15, 0.15, 0.15)
        
        if let levelModel = _level.value {
            modelLoader = EntityModelLoader(entityManager: levelModel.entityManager,
                                            wardrobe: wardrobe,
                                            root: levelView!)
        } else {
            modelLoader = nil
        }
    }
    
    func anchor(at parent: SCNNode?) {
        if let levelView = levelView {
            levelView.removeFromParentNode()
            parent?.addChildNode(levelView)
        }
    }
    
    func addNode(_ node: SCNNode) {
        if let levelView = levelView {
            levelView.addChildNode(node)
        }
    }
    
    func reset() {
        _level.value?.reset()
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
}
