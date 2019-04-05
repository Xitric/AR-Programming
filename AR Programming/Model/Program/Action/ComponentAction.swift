//
//  ComponentAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ComponentAction: Action {
    
    var strength = 1.0
    
    func run(onEntity entity: Entity, withProgramDelegate delegate: ProgramDelegate?, onCompletion: (() -> Void)?) {
        if let component = getActionComponent() {
            component.onComplete = {
                onCompletion?()
            }
            entity.addComponent(component)
        } else {
            onCompletion?()
        }
    }
    
    func getActionComponent() -> ActionComponent? {
        return nil
    }
}
