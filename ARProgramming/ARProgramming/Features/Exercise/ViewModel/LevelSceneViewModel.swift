//
//  LevelSceneViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 28/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import Level

/// A layer of abstraction built on top of the Level model to automatically manage its graphical representation in the UI.
///
/// This view model will synchronize the state of the Level model with a SceneKit representation.
class LevelSceneViewModel: LevelSceneViewModeling {

    // MARK: - Observers
    private var levelObserver: Observer?

    // MARK: - State
    private let levelContainer: CurrentLevelProtocol
    private let wardrobe: WardrobeRepository
    private var modelLoader: EntityModelLoader?
    private let levelView: SCNNode = {
        let node = SCNNode()
        node.scale = SCNVector3(0.15, 0.15, 0.15)
        return node
    }()
    private let _levelRedrawn = ObservableProperty<Void>(())

    var levelRedrawn: ImmutableObservableProperty<Void> {
        return _levelRedrawn
    }

    init(level: CurrentLevelProtocol, wardrobe: WardrobeRepository) {
        self.levelContainer = level
        self.wardrobe = wardrobe

        levelObserver = levelContainer.level.observe { [weak self] level in
            self?.display(level: level)
        }
    }

    deinit {
        levelObserver?.release()
    }

    // MARK: - Functionality
    func anchor(at parent: SCNNode?) {
        //Bugfix: com.apple.scenekit.scnview-renderer (89): EXC_BAD_ACCESS (code=1, address=0x4874176c0)
        levelContainer.level.value?.entityManager.invokeAfterUpdate { [weak self] in
            guard let self = self else { return }

            for child in parent?.childNodes ?? [] {
                child.removeFromParentNode()
            }
            self.levelView.removeFromParentNode()

            parent?.addChildNode(self.levelView)
        }
    }

    func addNode(_ node: SCNNode) {
        levelView.addChildNode(node)
    }

    private func display(level: LevelProtocol?) {
        clearSceneNode()

        if let level = level {
            modelLoader = EntityModelLoader(entityManager: level.entityManager,
                                            wardrobe: wardrobe,
                                            root: levelView)
        } else {
            modelLoader = nil
        }

        _levelRedrawn.value = ()
    }

    private func clearSceneNode() {
        for child in levelView.childNodes {
            child.removeFromParentNode()
        }
    }
}

protocol LevelSceneViewModeling {

    var levelRedrawn: ImmutableObservableProperty<Void> { get }

    /// Inform this view model about where to place the level in the SceneKit or AR scene.
    ///
    /// - Parameter parent: The node to anchor this level to, or nil to remove the level from its current anchor.
    func anchor(at parent: SCNNode?)

    /// Add a SCNNode to be displayed as part of this level.
    ///
    /// - Parameter node: The node to add.
    func addNode(_ node: SCNNode)
}
