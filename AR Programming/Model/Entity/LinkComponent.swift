//
//  LinkComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class LinkComponent: GKComponent {
    
    private var delta: simd_double3!
    
    let otherEntity: Entity
    
    init(otherEntity: Entity) {
        self.otherEntity = otherEntity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let transform = entity?.component(subclassOf: TransformComponent.self),
            let otherTransform = otherEntity.component(subclassOf: TransformComponent.self)
            else { return }
        
        delta = transform.rotation.inverse.act(otherTransform.location - transform.location)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let transform = entity?.component(subclassOf: TransformComponent.self),
            let otherTransform = otherEntity.component(subclassOf: TransformComponent.self)
            else { return }
        
        otherTransform.location = transform.location + transform.rotation.act(delta)
    }
}
