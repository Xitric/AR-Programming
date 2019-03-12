//
//  Program.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class Program {
    
    let start: CardNode?
    weak var delegate: ProgramDelegate?
    
    init(startNode: CardNode?) {
        start = startNode
    }
    
    func run(on entity: Entity) {
        delegate?.programBegan(self)
        run(start, on: entity)
    }
    
    private func run(_ node: CardNode?, on entity: Entity) {
        guard let node = node else {
            delegate?.programEnded(self)
            return
        }
        
        if let action = node.getCard().getAction() {
            action.onComplete = {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.program(self!, executed: node.getCard())
                    self?.run(node.next(), on: entity)
                }
            }
            entity.addComponent(action)
        } else {
            delegate?.program(self, executed: node.getCard())
            run(node.next(), on: entity)
        }
    }
}

protocol ProgramDelegate: class {
    func programBegan(_ program: Program)
    func program(_ program: Program, executed card: Card)
    func programEnded(_ program: Program)
}
