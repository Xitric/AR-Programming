//
//  EntityModelLoader.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class EntityModelLoader: EntityManagerDelegate {
    
    private let root: SCNNode
    
    init(entityManager: EntityManager, root: SCNNode) {
        self.root = root
        
        entityManager.delegate = self
        entityManager.addSystem(GKComponentSystem(componentClass: SCNNodeComponent.self))
        
        for entity in entityManager.getEntities(fromComponent: ResourceComponent.self) {
            tryLoadModel(forEntity: entity)
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
            nodeComponent = SCNNodeComponent(node: modelScene.rootNode)
        } else {
            //TODO: Better placeholder
            let geometry = SCNSphere(radius: 0.25)
            nodeComponent = SCNNodeComponent(node: SCNNode(geometry: geometry))
        }
        
        entity.addComponent(nodeComponent)
        root.addChildNode(nodeComponent.node)
    }
    
    private func tryRemoveModel(forEntity entity: Entity) {
        guard let nodeComponent = entity.component(ofType: SCNNodeComponent.self)
            else { return }
        
        nodeComponent.node.removeFromParentNode()
        entity.removeComponent(ofType: SCNNodeComponent.self)
    }
}
