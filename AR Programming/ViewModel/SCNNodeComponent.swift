//
//  SCNNodeComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class SCNNodeComponent: GKComponent {
    
    let node: SCNNode
    
    init(node: SCNNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: it would be lovely to avoid this
    override func update(deltaTime seconds: TimeInterval) {
        guard let entity = entity
            else { return }
        
        guard let transformComponent = entity.component(subclassOf: TransformComponent.self)
            else { return }
        
        node.simdPosition = simd_float3(Float(transformComponent.location.x),
                                        Float(transformComponent.location.y),
                                        Float(transformComponent.location.z))
        
//        TODO: We seriously need to handle this
//        transformComponent.location = simd_double3(node.simdPosition)
//        transformComponent.rotation = simd_quatd(node.simdOrientation)
//        transformComponent.scale = simd_double3(node.simdScale)
    }
}
