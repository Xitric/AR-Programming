//
//  CompoundActionComponentSystem.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CompoundActionComponentSystem: ActionComponentSystem<CompoundActionComponent> {
    
    override func performAction(forComponent component: CompoundActionComponent) {
        if let entity = component.entity {
            entity.addComponent(component.firstAction)
        } else {
            component.complete()
        }
    }
}
