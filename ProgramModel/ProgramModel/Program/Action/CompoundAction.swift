//
//  CompoundAction.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 21/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class CompoundAction: Action {
    
    private let firstAction: Action
    private let secondAction: Action
    
    init(_ firstAction: Action, _ secondAction: Action) {
        self.firstAction = firstAction
        self.secondAction = secondAction
    }
    
    func run(onEntity entity: Entity, withProgramDelegate delegate: ProgramDelegate?, onCompletion: (() -> Void)?) {
        firstAction.run(onEntity: entity, withProgramDelegate: delegate) { [weak self] in
            self?.secondAction.run(onEntity: entity, withProgramDelegate: delegate, onCompletion: onCompletion)
        }
    }
}
