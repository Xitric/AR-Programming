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
    
    func run(on robot: SCNNode) {
        delegate?.programBegan(self)
        run(start, on: robot)
        delegate?.programEnded(self)
    }
    
    private func run(_ node: CardNode?, on robot: SCNNode) {
        guard let node = node else {
            return
        }
        
        if let action = node.getCard().getAction(for: robot) {
            robot.runAction(action) { [weak self] in
                self?.delegate?.program(self!, executed: node.getCard())
                self?.run(node.next(), on: robot)
            }
        } else {
            delegate?.program(self, executed: node.getCard())
            run(node.next(), on: robot)
        }
    }
}

protocol ProgramDelegate: class {
    func programBegan(_ program: Program)
    func program(_ program: Program, executed card: Card)
    func programEnded(_ program: Program)
}
