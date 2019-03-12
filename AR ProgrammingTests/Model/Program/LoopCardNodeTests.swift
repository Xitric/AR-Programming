//
//  ParameterCardNodeTests.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 11/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class LoopCardNodeTests: XCTestCase {
    
    private var graph: ObservationGraph!
    private var observationSet: ObservationSet!
    
    private var prototypeStart: CardNode!
    private var prototypeLoop: CardNode!
    private var prototypeParameter2: CardNode!
    private var prototypeParameter3: CardNode!
    private var prototypeParameter4: CardNode!
    
    private var startNode: ObservationNode!
    private var loopNode: ObservationNode!
    
    override func setUp() {
        prototypeStart = try! CardNodeFactory.instance.cardNode(withCode: "0")
        prototypeLoop = try! CardNodeFactory.instance.cardNode(withCode: "6")
        prototypeParameter2 = try! CardNodeFactory.instance.cardNode(withCode: "9")
        prototypeParameter3 = try! CardNodeFactory.instance.cardNode(withCode: "10")
        prototypeParameter4 = try! CardNodeFactory.instance.cardNode(withCode: "11")
        
        startNode = ObservationNode(payload: "0", position: simd_double2(0,0), width: 0.8, height: 0.8)
        loopNode = ObservationNode(payload: "6", position: simd_double2(1, 0), width: 0.8, height: 0.8)
    }
    
    // Mark: - findParameterCard
    func testFindParameterCardTop(){
        //Arrange
        let parameterTopNode: ObservationNode = ObservationNode(payload: "9", position: simd_double2(1, -1), width: 0.8, height: 0.8)
        
        observationSet = ObservationSet()
        observationSet.add(startNode)
        observationSet.add(loopNode)
        observationSet.add(parameterTopNode)
       
        graph = ObservationGraph(observationSet: observationSet)
        
        //Act
        let _: CardNode = try! prototypeStart.create(from: startNode, in: graph, withParent: nil)
        let loopCardNode: LoopCardNode = try! prototypeLoop.create(from: loopNode, in: graph, withParent: prototypeStart) as! LoopCardNode
        let _: CardNode = try! prototypeParameter2.create(from: parameterTopNode, in: graph, withParent: nil)
        
        //Assert
        XCTAssertNotNil(loopCardNode)
        XCTAssertTrue(loopCardNode.repeats == 2)
    }
    
    func testFindParameterCardBottom(){
        //Arrange
        let parameterTopNode: ObservationNode = ObservationNode(payload: "10", position: simd_double2(1, 1), width: 0.8, height: 0.8)
        
        observationSet = ObservationSet()
        observationSet.add(startNode)
        observationSet.add(loopNode)
        observationSet.add(parameterTopNode)
        
        graph = ObservationGraph(observationSet: observationSet)
        
        //Act
        let _: CardNode = try! prototypeStart.create(from: startNode, in: graph, withParent: nil)
        let loopCardNode: LoopCardNode = try! prototypeLoop.create(from: loopNode, in: graph, withParent: prototypeStart) as! LoopCardNode
        let _: CardNode = try! prototypeParameter3.create(from: parameterTopNode, in: graph, withParent: nil)
        
        //Assert
        XCTAssertNotNil(loopCardNode)
        XCTAssertTrue(loopCardNode.repeats == 3)
    }
    
    func testFindParameterInvalidSide(){
        //Arrange
        let parameterRightNode: ObservationNode = ObservationNode(payload: "11", position: simd_double2(2, 0), width: 0.8, height: 0.8)
        
        observationSet = ObservationSet()
        observationSet.add(startNode)
        observationSet.add(loopNode)
        observationSet.add(parameterRightNode)
        
        graph = ObservationGraph(observationSet: observationSet)
 
        //Act
        let _: CardNode = try! prototypeStart.create(from: startNode, in: graph, withParent: nil)
        let loopCardNode: LoopCardNode = try! prototypeLoop.create(from: loopNode, in: graph, withParent: prototypeStart) as! LoopCardNode
        let _: CardNode = try! prototypeParameter4.create(from: parameterRightNode, in: graph, withParent: nil)
        
        //Assert
        XCTAssertNotNil(loopCardNode)
        XCTAssertNil(loopCardNode.repeats)
    }
}
