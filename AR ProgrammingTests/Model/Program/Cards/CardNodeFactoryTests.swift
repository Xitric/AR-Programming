//
//  CardNodeFactoryTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/3/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class CardNodeFactoryTests: XCTestCase {

    private var graph: ObservationGraph!
    private var node1: ObservationNode!
    private var node2: ObservationNode!
    private var node3: ObservationNode!
    private var node4: ObservationNode!
    private var node5: ObservationNode!
    private var node6: ObservationNode!
    
    // Layout by card number:
    //
    //   |6|2|
    // |5|1|3|
    //     |4|
    //
    override func setUp() {
        node1 = ObservationNode(code: 5, position: simd_double2(1, 0))
        node2 = ObservationNode(code: 1, position: simd_double2(2, 1))
        node3 = ObservationNode(code: 2, position: simd_double2(2, 0))
        node4 = ObservationNode(code: 4, position: simd_double2(2, -1))
        node5 = ObservationNode(code: 0, position: simd_double2(0, 0))
        node6 = ObservationNode(code: 9, position: simd_double2(1, 1))
        
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
        observationSet.add(node5)
        observationSet.add(node6)
        observationSet.uniquify(accordingTo: 1)
        
        graph = ObservationGraph(observationSet: observationSet, with: 0.5)
    }

    func testBuild_WithStart() {
        //Act
        let result = try? CardNodeFactory.instance.build(from: graph)
        
        //Assert
        XCTAssertNotNil(result)
        //TODO: We need to be able to see what nodes are created
    }
    
    func testBuild_MissingStart() {
        //Arrange
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.uniquify(accordingTo: 1)
        
        graph = ObservationGraph(observationSet: observationSet, with: 0.5)
        
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.build(from: graph)) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.missingStart)
        }
    }
    
    func testNodeForObservation_Single() {
        //TODO: We need to be able to see what nodes are created
    }
    
    func testNodeForObservation_Sequence() {
        //TODO: We need to be able to see what nodes are created
    }
    
    func testNodeForObservation_UnknownCode() {
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.node(for: node6, in: graph)) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.unknownCode(code: 9))
        }
    }

//    func node(for observation: ObservationNode, in graph: ObservationGraph) throws -> CardNode {
//        if let prototype = nodePrototypes[observation.code] {
//            return try prototype.create(from: observation, in: graph)
//        }
//
//        throw CardSequenceError.unknownCode(code: observation.code)
//    }
}
