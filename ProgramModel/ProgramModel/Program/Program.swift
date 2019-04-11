//
//  Program.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

class Program: ProgramProtocol {
    
    private var currentAction: Action?
    private let startNode: CardNode?
    
    weak var state: ProgramState!
    
    var start: CardNodeProtocol? {
        return startNode
    }
    weak var delegate: ProgramDelegate?
    
    init(startNode: CardNode?) {
        self.startNode = startNode
    }
    
    func run(on entity: Entity) {
        delegate?.programBegan(self)
        run(startNode, on: entity)
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
