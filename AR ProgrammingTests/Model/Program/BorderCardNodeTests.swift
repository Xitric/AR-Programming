//
//  BorderCardNodeTests.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 11/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class BorderCardNodeTests: XCTestCase {

    private var nodeStart: ObservationNode!
    private var nodeJump: ObservationNode!
    private var nodeParameter: ObservationNode!

    private var loopCardNode: LoopCardNode!
    private var borderCardNode: BorderCardNode!
    private var moveCardNode: SuccessorCardNode!
    private var jumpCardNode: SuccessorCardNode!
    
    override func setUp() {
        nodeStart = ObservationNode(payload: "0", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        nodeJump = ObservationNode(payload: "4", position: simd_double2(2, 0), width: 0.8, height: 0.8)
        nodeParameter = ObservationNode(payload: "11", position: simd_double2(1.2, 1), width: 0.8, height: 0.8)
        
        loopCardNode = LoopCardNode()
        borderCardNode = BorderCardNode()
        moveCardNode = SuccessorCardNode(card: MoveCard(), angles: [0])
        jumpCardNode = SuccessorCardNode(card: JumpCard(), angles: [0])
    }
    
    func testCreateWithoutParameter(){
        //Arrange: Loop, Jump, Border
        let nodeLoop = ObservationNode(payload: "6", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        let nodeBorder = ObservationNode(payload: "7", position: simd_double2(3, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(nodeStart)
        observationSet.add(nodeLoop)
        observationSet.add(nodeBorder)
        observationSet.add(nodeJump)
        let graph = ObservationGraph(observationSet: observationSet)
        
        
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.build(from: graph)) { error in
            XCTAssertNotNil(error as? CardSequenceError)
        }
    }
    
    func testFindLoopCard() {
        //Arrange
        let nodeLoop = ObservationNode(payload: "6", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        let nodeBorder = ObservationNode(payload: "7", position: simd_double2(3, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(nodeStart)
        observationSet.add(nodeLoop)
        observationSet.add(nodeJump)
        observationSet.add(nodeBorder)
        observationSet.add(nodeParameter)
        let graph = ObservationGraph(observationSet: observationSet)
        
        let start = try? CardNodeFactory.instance.build(from: graph)
        let loop = start?.successors[0]
        let jump = loop?.successors[0]
        let border = (jump?.successors[0]) as! BorderCardNode
        
        //Act
        let resultLoopCard = try? border.findLoopCard(in: graph)

        //Assert
        XCTAssertNotNil(resultLoopCard)
        XCTAssertTrue(resultLoopCard!.getCard().internalName == "loop")
        XCTAssertTrue(resultLoopCard! === loop)
    }
    
    
    func testFindLoopCardInvalid(){
        //Arrange
        let nodeLoop = ObservationNode(payload: "6", position: simd_double2(3, 0), width: 0.8, height: 0.8)
        let nodeBorder = ObservationNode(payload: "7", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(nodeStart)
        observationSet.add(nodeLoop)
        observationSet.add(nodeJump)
        observationSet.add(nodeBorder)
        observationSet.add(nodeParameter)
        let graph = ObservationGraph(observationSet: observationSet)
        
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.build(from: graph)) { error in
            XCTAssertNotNil(error as? CardSequenceError)
        }
    }
    
    func testNextWithLoopAsParent(){
        //Arrange: Loop, Border, Move
        borderCardNode.loopCardNode = loopCardNode
        borderCardNode.parent = loopCardNode
        borderCardNode.successors = [moveCardNode]
        loopCardNode.repeats = 2
        loopCardNode.successors = [borderCardNode]
        
        //Act
        let result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(borderCardNode.parent?.getCard().internalName == "loop")
        XCTAssertTrue(result === borderCardNode)
        XCTAssertTrue(borderCardNode.repeats == nil)
    }
    
    func testNextWithParameter(){
        //Arrange: Loop, Move, Border, Jump
        borderCardNode.loopCardNode = loopCardNode
        borderCardNode.parent = moveCardNode
        borderCardNode.successors = [jumpCardNode]
        moveCardNode.successors = [borderCardNode]
        loopCardNode.successors = [moveCardNode]
        
        //Act
        loopCardNode.repeats = 1
        var result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(result === jumpCardNode)
        
        //Act
        loopCardNode.repeats = 1
        result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(result === jumpCardNode)
        
        //Act
        loopCardNode.repeats = 4
        result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(result === moveCardNode)
    }
}
