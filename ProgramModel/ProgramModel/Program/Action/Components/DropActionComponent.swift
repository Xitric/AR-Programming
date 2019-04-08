//
//  DropActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class DropActionComponent: ActionComponent {
    
    override func didAddToEntityManager() {
        super.didAddToEntityManager()
        
        guard let link = entity?.component(subclassOf: LinkComponent.self),
        let entityTransform = entity?.component(subclassOf: TransformComponent.self),
        let collectibleTransform = link.otherEntity.component(subclassOf: TransformComponent.self) else {
            complete()
            return
        }
        
        entity?.removeComponent(ofType: LinkComponent.self)
        
        let dropVector = collectibleTransform.rotation.inverse.act(entityTransform.rotation.act(simd_double3(-0.5, -0.6, 0)))
        let moveAction = MovementActionComponent(movement: dropVector, duration: 1)
        moveAction.onComplete = { [weak self] in
            self?.complete()
        }
        link.otherEntity.addComponent(moveAction)
    }
}
