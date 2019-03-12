//
//  ActionComponentSystem.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ActionComponentSystem<T: ActionComponent>: GKComponentSystem<GKComponent> {
    
    override init() {
        super.init(componentClass: T.self)
    }
    
    override func addComponent(_ component: GKComponent) {
        super.addComponent(component)
        
        guard let component = component as? T
            else { return }
        
        performAction(forComponent: component)
    }
    
    func performAction(forComponent component: T) {
        fatalError("Must be overridden by subclasses!")
    }
}
