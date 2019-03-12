//
//  MoveActionComponentSystem.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class MoveActionComponentSystem: ActionComponentSystem<MoveActionComponent> {
    
    override func performAction(forComponent component: MoveActionComponent) {
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

extension MoveActionComponent {
    func sceneAction(forNode node: SCNNode) -> SCNAction {
        let axis = node.convertToLocal(axis: SCNVector3(movement))
        return SCNAction.move(by: axis, duration: duration)
    }
}
