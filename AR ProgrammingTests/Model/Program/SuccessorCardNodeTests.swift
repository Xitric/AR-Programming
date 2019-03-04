//
//  SuccessorCardNodeTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/3/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class SuccessorCardNodeTests: XCTestCase {

    private var graph: ObservationGraph!
    private var node1: ObservationNode!
    private var node2: ObservationNode!
    private var node3: ObservationNode!
    private var node4: ObservationNode!
    private var node5: ObservationNode!
    private var node6: ObservationNode!
    
    // Layout by card number:
    //
    //   |3|2| |6|
    // |1|
    //   |4|
    // |5|
    //
    override func setUp() {
        node1 = ObservationNode(payload: "5", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        node2 = ObservationNode(payload: "2", position: simd_double2(2, 1), width: 0.8, height: 0.8)
        node3 = ObservationNode(payload: "3", position: simd_double2(1, 1), width: 0.8, height: 0.8)
        node4 = ObservationNode(payload: "4", position: simd_double2(1, -1), width: 0.8, height: 0.8)
        node5 = ObservationNode(payload: "5", position: simd_double2(0, -2), width: 0.8, height: 0.8)
        node6 = ObservationNode(payload: "2", position: simd_double2(4, 1), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
        observationSet.add(node5)
        observationSet.add(node6)
        
        graph = ObservationGraph(observationSet: observationSet)
    }
    
    //MARK: create
    func testCreate_SingleSuccessor() {
        //Arrange
        let prototype = try! CardNodeFactory.instance.cardNode(withCode: "2")
        
        //Act
        let result = try? prototype.create(from: node2, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertEqual(result!.successors[0]?.getCard().internalName,
                       try! CardNodeFactory.instance.cardNode(withCode: "3").getCard().internalName)
        XCTAssertNotNil(graph.edge(from: node2, to: node3))
    }
    
    func testCreate_MultipleSuccessors() {
        //Arrange
        let prototype = try! CardNodeFactory.instance.cardNode(withCode: "5")
        
        //Act
        let result = try? prototype.create(from: node1, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.successors.count, 2)
        XCTAssertEqual(result!.successors[0]?.getCard().internalName,
                       try! CardNodeFactory.instance.cardNode(withCode: "3").getCard().internalName)
        XCTAssertEqual(result!.successors[1]?.getCard().internalName,
                       try! CardNodeFactory.instance.cardNode(withCode: "4").getCard().internalName)
        XCTAssertNotNil(graph.edge(from: node1, to: node3))
        XCTAssertNotNil(graph.edge(from: node1, to: node4))
    }
    
    func testCreate_NoSuccessor() {
        //Arrange
        let prototype = try! CardNodeFactory.instance.cardNode(withCode: "2")
        
        //Act
        let result = try? prototype.create(from: node6, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertNil(result!.successors[0])
    }
    
    func testCreate_MultipleSuccessorsOneMissing() {
        //Arrange
        let prototype = try! CardNodeFactory.instance.cardNode(withCode: "5")
        
        //Act
        let result = try? prototype.create(from: node5, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.successors.count, 2)
        XCTAssertEqual(result!.successors[0]?.getCard().internalName,
                       try! CardNodeFactory.instance.cardNode(withCode: "4").getCard().internalName)
        XCTAssertNil(result!.successors[1])
        XCTAssertNotNil(graph.edge(from: node5, to: node4))
    }
}
