//
//  SuccessorCardNodeTests.swift
//  VisionCardTestTests
//
//  Created by user143563 on 2/3/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import XCTest
@testable import AR_Programming

class SuccessorCardNodeTests: XCTestCase {

    func testExample() {
        
    }
    
    
    
//    func create(from node: ObservationNode, in graph: ObservationGraph) throws -> CardNode {
//        let clone = SuccessorCardNode(card: card, angles: successorAngles)
//
//        for angle in successorAngles {
//            if let next = graph.getSuccessor(by: angle, to: node) {
//                graph.connect(from: node, to: next, with: angle)
//                clone.successors.append(try CardNodeFactory.instance.node(for: next, in: graph))
//            } else {
//                clone.successors.append(nil)
//            }
//        }
//
//        return clone
//    }
//
//    func execute(on robot: SCNNode) {
//        let branch = card.execute(on: robot)
//
//        if branch >= 0 && branch < successors.count {
//            successors[branch]?.execute(on: robot)
//        }
//    }
}
