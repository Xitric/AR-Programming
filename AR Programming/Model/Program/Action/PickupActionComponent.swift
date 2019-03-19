//
//  PickupActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class PickupActionComponent: ActionComponent {
    
    override func didAddToEntityManager() {
        super.didAddToEntityManager()
        
        //If we are already holding something, we cannot pick up something new
        if entity?.component(ofType: LinkComponent.self) != nil {
            complete()
            return
        }
        
        //We need to be able to detect a collision with the other entity, as well as to have an EntityManager for finding other entities to collect
        guard let entityTransform = entity?.component(subclassOf: TransformComponent.self),
        let entityCollision = entity?.component(subclassOf: CollisionComponent.self),
        let entityManager = entityManager else {
            complete()
            return
        }
        
        //Look for something to pick up
        for collectible in entityManager.getEntities(withComponents: CollectibleComponent.self, CollisionComponent.self) {
            let collectibleCollision = collectible.component(ofType: CollisionComponent.self)!
            
            if entityCollision.collidesWith(other: collectibleCollision) {
                let pickupVector = entityTransform.rotation.act(simd_double3(0.5, 0.6, 0))
                let moveAction = MovementActionComponent(movement: pickupVector, duration: 1)
                moveAction.onComplete = { [weak self] in
                    self?.entity?.addComponent(LinkComponent(otherEntity: collectible))
                    self?.complete()
                }
                collectible.addComponent(moveAction)
                return
            }
        }
        
        complete()
    }
}
