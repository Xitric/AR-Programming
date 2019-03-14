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
        
        inject(nodeComponent: nodeComponent, intoEntity: entity)
        root.addChildNode(nodeComponent.node)
    }
    
    private func inject(nodeComponent: SCNNodeComponent, intoEntity entity: Entity) {
        if let currentTransform = entity.component(subclassOf: TransformComponent.self) {
            nodeComponent.location = currentTransform.location
            nodeComponent.rotation = currentTransform.rotation
            nodeComponent.scale = currentTransform.scale
            entity.removeComponent(ofType: type(of: currentTransform))
        }
        
        entity.addComponent(nodeComponent)
    }
    
    private func tryRemoveModel(forEntity entity: Entity) {
        guard let nodeComponent = entity.component(ofType: SCNNodeComponent.self)
            else { return }
        
        nodeComponent.node.removeFromParentNode()
        extractNodeComponent(fromEntity: entity)
    }
    
    private func extractNodeComponent(fromEntity entity: Entity) {
        if let currentTransform = entity.component(subclassOf: SCNNodeComponent.self) {
            let transformComponent = TransformComponent()
            transformComponent.location = currentTransform.location
            transformComponent.rotation = currentTransform.rotation
            transformComponent.scale = currentTransform.scale
            entity.addComponent(transformComponent)
        }
        
        entity.removeComponent(ofType: SCNNodeComponent.self)
    }
}
