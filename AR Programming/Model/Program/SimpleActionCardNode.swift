//
//  SimpleActionCardNode.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class SimpleActionCardNode: CardNode {
    
    private let action: ComponentAction
    
    init(name: String, action: ComponentAction) {
        self.action = action
        super.init(card: BasicCard(
            internalName: name,
            supportsParameter: true,
            requiresParameter: false,
            connectionAngles: [0]))
    }
    
    override func clone() -> CardNode {
        return SimpleActionCardNode(name: card.internalName, action: action)
    }
    
    override func getAction(forEntity entity: Entity, withProgramState state: ProgramState) -> Action? {
        action.strength = Double(parameter ?? 1)
        return action
    }
}
