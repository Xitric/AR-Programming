//
//  Program.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

public class Program {
    
    private var currentAction: Action?
    
    weak var state: ProgramState!
    
    public let start: CardNode?
    public weak var delegate: ProgramDelegate?
    
    init(startNode: CardNode?) {
        start = startNode
    }
    
    public func run(on entity: Entity) {
        delegate?.programBegan(self)
        run(start, on: entity)
    }
    
    private func run(_ node: CardNode?, on entity: Entity) {
        guard let node = node else {
            delegate?.programEnded(self)
            return
        }
        
        if let action = node.getAction(forEntity: entity, withProgramState: state) {
            currentAction = action
            action.run(onEntity: entity, withProgramDelegate: delegate) { [weak self] in
                self?.delegate?.program(self!, executed: node.card)
                self?.run(node.next(), on: entity)
            }
        } else {
            delegate?.program(self, executed: node.card)
            run(node.next(), on: entity)
        }
    }
}

public protocol ProgramDelegate: class {
    func programBegan(_ program: Program)
    func program(_ program: Program, executed card: Card)
    func programEnded(_ program: Program)
}