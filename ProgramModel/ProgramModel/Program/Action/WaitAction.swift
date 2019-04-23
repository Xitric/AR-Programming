//
//  WaitAction.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 21/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class WaitAction: Action {
    
    private let waitTime: Double
    
    init(waitTime: Double) {
        self.waitTime = waitTime
    }
    
    func run(onEntity entity: Entity, withProgramDelegate delegate: ProgramDelegate?, onCompletion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + waitTime) {
            onCompletion?()
        }
    }
}
