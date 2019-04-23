//
//  ProgramAction.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class ProgramAction: Action, ProgramDelegate {
    
    private var delegate: ProgramDelegate?
    private var completion: (() -> Void)?
    
    let program: ProgramProtocol
    
    init(program: ProgramProtocol) {
        self.program = program
    }
    
    func run(onEntity entity: Entity, withProgramDelegate delegate: ProgramDelegate?, onCompletion: (() -> Void)?) {
        self.delegate = delegate
        self.completion = onCompletion
        program.delegate = self
        program.run(on: entity)
    }
    
    func programBegan(_ program: ProgramProtocol) {
        // Ignored
    }
    
    func program(_ program: ProgramProtocol, willExecute cardNode: CardNodeProtocol) {
        delegate?.program(program, willExecute: cardNode)
    }
    
    func program(_ program: ProgramProtocol, executed cardNode: CardNodeProtocol) {
        delegate?.program(program, executed: cardNode)
    }
    
    func programEnded(_ program: ProgramProtocol) {
        completion?()
    }
}
