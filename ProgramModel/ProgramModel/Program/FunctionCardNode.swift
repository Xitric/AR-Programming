//
//  FunctionCardNode.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class FunctionCardNode: CardNode {
    
    private let functionNumber: Int
    private let isCaller: Bool
    
    init(functionNumber: Int, isCaller: Bool) {
        self.functionNumber = functionNumber
        self.isCaller = isCaller
        super.init(card: BasicCard(
            internalName: "function\(functionNumber)\(isCaller ? "b" : "a")",
            type: .control,
            supportsParameter: false,
            requiresParameter: false,
            connectionAngles: [0]))
    }
    
    override func clone() -> CardNode {
        return FunctionCardNode(functionNumber: functionNumber, isCaller: isCaller)
    }
    
    override func getAction(forEntity entity: Entity, withProgramState state: ProgramState) -> Action? {
        if isCaller {
            if let function = state.getProgram(forCard: card) {
                return ProgramAction(program: function)
            }
        }
        
        return nil
    }
}
