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

class CardNodeTests: XCTestCase {

    private var graph: ObservationGraph!
    private var node1: ObservationNode!
    private var node2: ObservationNode!
    private var node3: ObservationNode!
    private var node4: ObservationNode!
    private var node5: ObservationNode!
    
    // Layout by card number:
    //
    //   |4|
    // |1|3|2| |5|
    //
    override func setUp() {
        node1 = ObservationNode(payload: "4", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        node2 = ObservationNode(payload: "2", position: simd_double2(2, 0), width: 0.8, height: 0.8)
        node3 = ObservationNode(payload: "3", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        node4 = ObservationNode(payload: "11", position: simd_double2(1, 1), width: 0.8, height: 0.8)
        node5 = ObservationNode(payload: "2", position: simd_double2(4, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
        observationSet.add(node5)
        
        graph = ObservationGraph(observationSet: observationSet)
    }
    
    //MARK: create
    func testCreate_SingleSuccessor() {
        //Arrange
        let prototype = try! CardNodeFactory.instance.cardNode(withCode: "2")
        
        //Act
        let result = try? prototype.create(from: node2, withParent: nil, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertNil(result?.parent)
        XCTAssertEqual(result!.successors.count, 1)
        
        let successorResult: CardNode? = result!.successors[0]
        XCTAssertEqual(successorResult?.card.internalName,
                       try! CardNodeFactory.instance.cardNode(withCode: "3").card.internalName)
        XCTAssertTrue(successorResult!.parent === result)
        XCTAssertNotNil(graph.edge(from: node2, to: node3))
    }
    
    func testCreate_NoSuccessor() {
        //Arrange
        let prototype = try! CardNodeFactory.instance.cardNode(withCode: "2")
        
        //Act
        let result = try? prototype.create(from: node5, withParent: nil, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertNil(result?.parent)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertNil(result!.successors[0])
    }
    
    func testCreate_Parameter() {
        //Arrange
        let prototype = try! CardNodeFactory.instance.cardNode(withCode: "2")
        
        //Act
        var result = try? prototype.create(from: node2, withParent: nil, in: graph)
        
        //Assert
        let node1Param = result?.children.first {
            $0.card is ParameterCard
        }
        XCTAssertNil(node1Param)
        
        result = result?.successors[0]
        let node3Param = result?.children.first {
            $0.card is ParameterCard
        }
        XCTAssertNotNil(node3Param)
        XCTAssertEqual(result?.parameter, 4)
    }
}
