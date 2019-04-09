//
//  BorderCardNodeTests.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 11/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class BorderCardNodeTests: XCTestCase {

    private var factory: CardNodeFactory!
    private var programBuilder: ObservationGraphCardNodeBuilder!
    
    private var nodeStart: ObservationNode!
    private var nodeJump: ObservationNode!
    private var nodeParameter: ObservationNode!

    private var loopCardNode: LoopCardNode!
    private var borderCardNode: BorderCardNode!
    private var moveCardNode: CardNode!
    private var jumpCardNode: CardNode!
    
    override func setUp() {
        factory = CardNodeFactory()
        programBuilder = ObservationGraphCardNodeBuilder()
        
        nodeStart = ObservationNode(payload: "0", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        nodeJump = ObservationNode(payload: "4", position: simd_double2(2, 0), width: 0.8, height: 0.8)
        nodeParameter = ObservationNode(payload: "11", position: simd_double2(1.2, 1), width: 0.8, height: 0.8)
        
        loopCardNode = LoopCardNode()
        borderCardNode = BorderCardNode()
        moveCardNode = SimpleActionCardNode(name: "move", action: MoveAction())
        jumpCardNode = SimpleActionCardNode(name: "jump", action: JumpAction())
    }
    
    //MARK: create
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
        let startObservation = graph.firstNode(withPayloadIn: factory.functionDeclarationCodes)!
        XCTAssertThrowsError(try programBuilder
            .using(factory: factory)
            .createFrom(graph: graph)
            .using(node: startObservation)
            .getResult()) { error in
            XCTAssertNotNil(error as? CardSequenceError)
        }
    }
    
    //MARK: findLoop
    func testFindLoop() {
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
        
        let start = try? programBuilder
            .using(factory: factory)
            .createFrom(graph: graph)
            .getResult()
        let loop = start?.successors[0]
        let jump = loop?.successors[0]
        let border = (jump?.successors[0]) as! BorderCardNode
        
        //Act
        try? border.findLoop()
        let resultLoopCard = border.loopCardNode

        //Assert
        XCTAssertNotNil(resultLoopCard)
        XCTAssertTrue(resultLoopCard!.card.internalName == "loop")
        XCTAssertTrue(resultLoopCard! === loop)
    }
    
    func testFindLoop_Invalid(){
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
        XCTAssertThrowsError(try programBuilder
            .using(factory: factory)
            .createFrom(graph: graph)
            .getResult()) { error in
            XCTAssertNotNil(error as? CardSequenceError)
        }
    }
    
    func testFindLoop_Nested() {
        //Arrange
        //Arrange
        let nodeOuterLoop = ObservationNode(payload: "6", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        let nodeInnerLoop = ObservationNode(payload: "6", position: simd_double2(3, 0), width: 0.8, height: 0.8)
        let nodeInnerParameter = ObservationNode(payload: "11", position: simd_double2(3, 1), width: 0.8, height: 0.8)
        let nodeInnerBorder = ObservationNode(payload: "7", position: simd_double2(4, 0), width: 0.8, height: 0.8)
        let nodeOuterBorder = ObservationNode(payload: "7", position: simd_double2(5, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(nodeStart)
        observationSet.add(nodeOuterLoop)
        observationSet.add(nodeParameter)
        observationSet.add(nodeJump)
        observationSet.add(nodeInnerLoop)
        observationSet.add(nodeInnerParameter)
        observationSet.add(nodeInnerBorder)
        observationSet.add(nodeOuterBorder)
        let graph = ObservationGraph(observationSet: observationSet)
        
        let start = try? programBuilder
            .using(factory: factory)
            .createFrom(graph: graph)
            .getResult()
        let outerLoop = start?.successors[0]
        let jump = outerLoop?.successors[0]
        let innerLoop = jump?.successors[0]
        let innerBorder = (innerLoop?.successors[0]) as! BorderCardNode
        let outerBorder = (innerBorder.successors[0]) as! BorderCardNode
        
        //Act
        try? outerBorder.findLoop()
        let resultOuterLoopCard = outerBorder.loopCardNode
        
        try? innerBorder.findLoop()
        let resultInnerLoopCard = innerBorder.loopCardNode
        
        //Assert
        XCTAssertNotNil(resultOuterLoopCard)
        XCTAssertTrue(resultOuterLoopCard?.card.internalName == "loop")
        XCTAssertTrue(resultOuterLoopCard === outerLoop)
        
        XCTAssertNotNil(resultInnerLoopCard)
        XCTAssertTrue(resultInnerLoopCard?.card.internalName == "loop")
        XCTAssertTrue(resultInnerLoopCard === innerLoop)
    }
    
    //MARK: next
    func testNextWithLoopAsParent(){
        //Arrange: Loop, Border, Move
        borderCardNode.loopCardNode = loopCardNode
        borderCardNode.parent = loopCardNode
        borderCardNode.addSuccessor(moveCardNode)
        loopCardNode.parameter = 2
        loopCardNode.addSuccessor(borderCardNode)
        try? borderCardNode.findLoop()
        
        //Act
        let result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(borderCardNode.parent?.card.internalName == "loop")
        XCTAssertTrue(result === borderCardNode)
        XCTAssertTrue(borderCardNode.remainingRepeats == 1)
    }
    
    func testNextWithParameter(){
        //Arrange: Loop, Move, Border, Jump
        moveCardNode.parent = loopCardNode
        borderCardNode.parent = moveCardNode
        borderCardNode.addSuccessor(jumpCardNode)
        moveCardNode.addSuccessor(borderCardNode)
        loopCardNode.addSuccessor(moveCardNode)
        
        //Act
        loopCardNode.parameter = 1
        try? borderCardNode.findLoop()
        var result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(result === jumpCardNode)
        
        //Act
        loopCardNode.parameter = 1
        try? borderCardNode.findLoop()
        result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(result === jumpCardNode)
        
        //Act
        loopCardNode.parameter = 4
        try? borderCardNode.findLoop()
        result = borderCardNode.next()
        
        //Assert
        XCTAssertTrue(result === moveCardNode)
    }
}
