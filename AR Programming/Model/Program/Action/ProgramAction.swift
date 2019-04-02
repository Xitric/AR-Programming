//
//  ProgramAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ProgramAction: Action, ProgramDelegate {
    
    private var delegate: ProgramDelegate?
    private var completion: (() -> Void)?
    
    let program: Program
    
    init(program: Program) {
        self.program = program
    }
    
    func run(onEntity entity: Entity, withProgramDelegate delegate: ProgramDelegate?, onCompletion: (() -> Void)?) {
        self.delegate = delegate
        self.completion = onCompletion
        program.delegate = self
        program.run(on: entity)
    }
    
    func programBegan(_ program: Program) {
        // Ignored
    }
    
    func program(_ program: Program, executed card: Card) {
        delegate?.program(program, executed: card)
    }
    
    func programEnded(_ program: Program) {
        completion?()
    }
}
