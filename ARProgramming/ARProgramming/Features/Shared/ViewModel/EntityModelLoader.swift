//
//  EntityModelLoader.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import EntityComponentSystem

class EntityModelLoader: EntityManagerDelegate {

    private let wardrobe: WardrobeRepository
    private let root: SCNNode

    init(entityManager: EntityManager, wardrobe: WardrobeRepository, root: SCNNode) {
        self.wardrobe = wardrobe
        self.root = root

        entityManager.delegate = self

        wardrobe.selectedRobotSkin { [weak self] skin, _ in
            let playerResource = ResourceComponent(resourceIdentifier: skin ?? "")
            entityManager.player.addComponent(playerResource)

            for entity in entityManager.getEntities(withComponents: ResourceComponent.self) {
                self?.tryLoadModel(forEntity: entity)
            }
        }
    }

    func entityManager(_ entityManager: EntityManager, added entity: Entity) {
        tryLoadModel(forEntity: entity)
    }

    func entityManager(_ entityManager: EntityManager, removed entity: Entity) {
        tryRemoveModel(forEntity: entity)
    }

    private func tryLoadModel(forEntity entity: Entity) {
        guard let resourceComponent = entity.component(subclassOf: ResourceComponent.self)
            else { return }

        let nodeComponent: SCNNodeComponent
        let resourceLocation = "Meshes.scnassets/\(resourceComponent.resourceIdentifier).dae"
        if let modelScene = SCNScene(named: resourceLocation) {
            let node = SCNNode()
            for child in modelScene.rootNode.childNodes {
                node.addChildNode(child)
            }
            nodeComponent = SCNNodeComponent(node: node)
        } else {
            let geometry = SCNSphere(radius: 0.25)
            nodeComponent = SCNNodeComponent(node: SCNNode(geometry: geometry))
        }

        inject(nodeComponent: nodeComponent, intoEntity: entity)
        root.addChildNode(nodeComponent.node)
    }

    private func inject(nodeComponent: SCNNodeComponent, intoEntity entity: Entity) {
        if let currentTransform = entity.component(subclassOf: TransformComponent.self) {
            nodeComponent.location = currentTransform.location
            nodeComponent.rotation = currentTransform.rotation

            entity.removeComponent(ofType: type(of: currentTransform))
            entity.addComponent(nodeComponent)
        }
    }

    private func tryRemoveModel(forEntity entity: Entity) {
        guard let nodeComponent = entity.component(ofType: SCNNodeComponent.self)
            else { return }

        nodeComponent.node.removeFromParentNode()
        extractNodeComponent(fromEntity: entity)
    }

    private func extractNodeComponent(fromEntity entity: Entity) {
        if let currentTransform = entity.component(subclassOf: SCNNodeComponent.self) {
            let transformComponent = TransformComponent(location: currentTransform.location,
                                                        rotation: currentTransform.rotation)

            entity.removeComponent(ofType: SCNNodeComponent.self)
            entity.addComponent(transformComponent)
        }
    }
}
