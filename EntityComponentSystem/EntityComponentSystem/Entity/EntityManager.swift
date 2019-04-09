//
//  EntityManager.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

public protocol EntityManagerDelegate: class {
    func entityManager(_ entityManager: EntityManager, added entity: Entity)
    func entityManager(_ entityManager: EntityManager, removed entity: Entity)
}

public class EntityManager: NSObject {
    
    private var systems = [String:GKComponentSystem]()
    private var entities = [Entity]()
    private var closureQueue = [() -> Void]()
    
    public weak var delegate: EntityManagerDelegate?
    public var player: Entity
    
    public override init() {
        player = Entity()
        
        super.init()
        
        player.addComponent(TransformComponent())
        player.addComponent(CollisionComponent(size: simd_double3(0.5, 0.5, 0.5), offset: simd_double3(0, 0.25, 0)))
        addEntity(player)
    }
    
    public func addEntity(_ entity: Entity) {
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
    
    public func removeEntity(_ entity: Entity) {
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
    
    public func addSystem(_ system: GKComponentSystem<GKComponent>) {
        for entity in entities {
            system.addComponent(foundIn: entity)
        }
        
        systems[String(describing: system.componentClass)] = system
    }
    
    public func removeSystem(forComponent componentType: GKComponent.Type) {
        let systemString = String(describing: componentType)
        guard let system = systems[systemString] else {
            return
        }
        
        for entity in entities {
            system.removeComponent(foundIn: entity)
        }
        
        systems[systemString] = nil
    }
    
    public func update(delta: TimeInterval) {
        for entity in entities {
            entity.update(deltaTime: delta)
        }
        
        if !closureQueue.isEmpty {
            //Iterate over a copy to allow new closures to be added from other closures
            let closuresToRun = closureQueue
            closureQueue.removeAll()
            for closure in closuresToRun {
                closure()
            }
        }
    }
    
    public func getEntities(withComponents componentTypes: GKComponent.Type...) -> [Entity] {
        return entities.filter { entity in
            checkComponentsOnEntity(entity: entity, componentTypes: componentTypes)
        }
    }
    
    private func checkComponentsOnEntity(entity: Entity, componentTypes: [GKComponent.Type]) -> Bool {
        for cType in componentTypes {
            if entity.component(subclassOf: cType) == nil {
                return false
            }
        }
        return true
    }
    
    public func invokeAfterUpdate(closure: @escaping () -> Void) {
        closureQueue.append(closure)
    }
}

// MARK: - EntityDelegate
extension EntityManager: EntityDelegate {
    private func system(forComponent component: GKComponent) -> GKComponentSystem<GKComponent>? {
        return systems[String(describing: type(of: component))]
    }
    
    public func entity(_ entity: Entity, addedComponent component: GKComponent) {
        system(forComponent: component)?.addComponent(component)
        
        if let component = component as? Component {
            component.entityManager = self
        }
    }
    
    public func entity(_ entity: Entity, removedComponent component: GKComponent) {
        system(forComponent: component)?.removeComponent(component)
        
        if let component = component as? Component {
            component.entityManager = nil
        }
    }
}
