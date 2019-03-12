//
//  RotateActionComponentSystem.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class RotateActionComponentSystem: ActionComponentSystem<RotateActionComponent> {
    
    override func performAction(forComponent component: RotateActionComponent) {
        if let node = component.entity?.component(ofType: SCNNodeComponent.self)?.node {
            let action = component.sceneAction(forNode: node)
            node.runAction(action) {
                component.complete()
            }
        } else {
            component.complete()
        }
    }
}

extension RotateActionComponent {
    func sceneAction(forNode node: SCNNode) -> SCNAction {
        let axis = node.convertToLocal(axis: SCNVector3(rotation.axis))
        return SCNAction.rotate(by: CGFloat(rotation.angle), around: axis, duration: duration)
    }
}
