//
//  EntityManager.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

protocol EntityManagerDelegate: class {
    func entityManager(_ entityManager: EntityManager, added entity: Entity)
    func entityManager(_ entityManager: EntityManager, removed entity: Entity)
}

class EntityManager {
    
    private var systems = [String:GKComponentSystem]()
    private var entities = [Entity]()
    
    weak var delegate: EntityManagerDelegate?
    var player: Entity
    
    init() {
        player = Entity()
        player.addComponent(TransformComponent())
        player.addComponent(ResourceComponent(resourceIdentifier: "Bot"))
        addEntity(player)
    }
    
    func addEntity(_ entity: Entity) {
        entity.delegate = self
        entities.append(entity)
        
        for system in systems.values {
            system.addComponent(foundIn: entity)
        }
        
        for component in entity.components {
            if let component = component as? Component {
               component.entityManager = self
            }
        }
        
        delegate?.entityManager(self, added: entity)
    }
    
    func removeEntity(_ entity: Entity) {
        entity.delegate = nil
        if let index = entities.firstIndex(where: {$0 === entity}) {
            entities.remove(at: index)
        }
        
        for system in systems.values {
            system.removeComponent(foundIn: entity)
        }
        
        for component in entity.components {
            if let component = component as? Component {
                component.entityManager = nil
            }
        }
        
        delegate?.entityManager(self, removed: entity)
    }
    
    func addSystem(_ system: GKComponentSystem<GKComponent>) {
        for entity in entities {
            system.addComponent(foundIn: entity)
        }
        
        systems[String(describing: system.componentClass)] = system
    }
    
    func removeSystem(forComponent componentType: GKComponent.Type) {
        let systemString = String(describing: componentType)
        guard let system = systems[systemString] else {
            return
        }
        
        for entity in entities {
            system.removeComponent(foundIn: entity)
        }
        
        systems[systemString] = nil
    }
    
    func update(delta: TimeInterval) {
        for system in systems.values {
            system.update(deltaTime: delta)
        }
        
        for entity in entities {
            entity.update(deltaTime: delta)
        }
    }
    
    func getEntities(fromComponent componentTypes: GKComponent.Type...) -> [Entity] {
        var entitiesWithComponent = [Entity]()
        for entity in entities {
            if checkComponentsOnEntity(entity: entity, componentTypes: componentTypes){
                entitiesWithComponent.append(entity)
            }
        }
        return entitiesWithComponent
    }
    
    private func checkComponentsOnEntity(entity: Entity, componentTypes: [GKComponent.Type]) -> Bool {
        for cType in componentTypes {
            if entity.component(subclassOf: cType) == nil{
                return false
            }
        }
        return true
    }
}

// MARK: - EntityDelegate
extension EntityManager: EntityDelegate {
    private func system(forComponent component: GKComponent) -> GKComponentSystem<GKComponent>? {
        return systems[String(describing: type(of: component))]
    }
    
    func entity(_ entity: Entity, addedComponent component: GKComponent) {
        system(forComponent: component)?.addComponent(component)
        
        if let component = component as? Component {
            component.entityManager = self
        }
    }
    
    func entity(_ entity: Entity, removedComponent component: GKComponent) {
        system(forComponent: component)?.removeComponent(component)
        
        if let component = component as? Component {
            component.entityManager = nil
        }
    }
}
