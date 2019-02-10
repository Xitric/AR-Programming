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
    private var node7: ObservationNode!
    
    // Layout by card number:
    //
    //   |6|2|
    // |5|1|3| |7|
    //     |4|
    //
    override func setUp() {
        node1 = ObservationNode(code: 5, position: simd_double2(1, 0))
        node2 = ObservationNode(code: 1, position: simd_double2(2, 1))
        node3 = ObservationNode(code: 2, position: simd_double2(2, 0))
        node4 = ObservationNode(code: 4, position: simd_double2(2, -1))
        node5 = ObservationNode(code: 0, position: simd_double2(0, 0))
        node6 = ObservationNode(code: 9, position: simd_double2(1, 1))
        node7 = ObservationNode(code: 3, position: simd_double2(4, 0))
        
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
        observationSet.add(node5)
        observationSet.add(node6)
        observationSet.add(node7)
        observationSet.uniquify(accordingTo: 1)
        
        graph = ObservationGraph(observationSet: observationSet, with: 1)
    }
    
    private func assert(cardNode: CardNode, matchesObservation observationNode: ObservationNode) {
        XCTAssertEqual(cardNode.getCard().internalName,
                       try! CardNodeFactory.instance.node(withId: observationNode.code).getCard().internalName)
        XCTAssertEqual(cardNode.position, observationNode.position)
    }

    func testBuild_WithStart() {
        //Act
        var result = try? CardNodeFactory.instance.build(from: graph)
        
        //Assert
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node5)
        XCTAssertEqual(result!.successors.count, 1)
        
        result = result!.successors[0]
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node1)
        XCTAssertEqual(result!.successors.count, 2)
        
        let topBranch = result!.successors[0]
        XCTAssertNotNil(topBranch)
        assert(cardNode: topBranch!, matchesObservation: node2)
        XCTAssertEqual(topBranch!.successors.count, 1)
        XCTAssertNil(topBranch!.successors[0])
        
        let bottomBranch = result!.successors[1]
        XCTAssertNotNil(bottomBranch)
        assert(cardNode: bottomBranch!, matchesObservation: node4)
        XCTAssertEqual(bottomBranch!.successors.count, 1)
        XCTAssertNil(bottomBranch!.successors[0])
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
        //Act
        let result = try? CardNodeFactory.instance.node(for: node7, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node7)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertNil(result!.successors[0])
    }
    
    func testNodeForObservation_Sequence() {
        //Act
        var result: CardNode? = try! CardNodeFactory.instance.node(for: node5, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node5)
        XCTAssertEqual(result!.successors.count, 1)
        
        result = result!.successors[0]
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node1)
        XCTAssertEqual(result!.successors.count, 2)
    }
    
    func testNodeForObservation_UnknownCode() {
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.node(for: node6, in: graph)) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.unknownCode(code: 9))
        }
    }
    
    func testNodeWithId_ValidId() {
        //Act
        let result = try? CardNodeFactory.instance.node(withId: 3)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.getCard().internalName, "right")
    }
    
    func testNodeWithId_UnknownId() {
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.node(withId: -1)) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.unknownCode(code: -1))
        }
    }
    
    func testRegister_NewNode() {
        //Act
        CardNodeFactory.instance.register(cardNode: SuccessorCardNode(card: LeftCard(), angles: [0]), with: 200)
        CardNodeFactory.instance.register(cardNode: SuccessorCardNode(card: JumpCard(), angles: [0]), with: -6)
        
        //Assert
        let leftCard = try? CardNodeFactory.instance.node(withId: 200)
        XCTAssertNotNil(leftCard)
        XCTAssertEqual(leftCard?.getCard().internalName, "left")
        
        let jumpCard = try? CardNodeFactory.instance.node(withId: -6)
        XCTAssertNotNil(jumpCard)
        XCTAssertEqual(jumpCard?.getCard().internalName, "jump")
    }
    
    func testRegister_ExistingNode() {
        //Act
        let cardNode = SuccessorCardNode(card: LeftCard(), angles: [0])
        CardNodeFactory.instance.register(cardNode: cardNode, with: 3)
        
        //Assert
        let result = try? CardNodeFactory.instance.node(withId: 3)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.getCard().internalName, cardNode.getCard().internalName)
    }
}
