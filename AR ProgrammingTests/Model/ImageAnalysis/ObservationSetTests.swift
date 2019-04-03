//
//  ObservationSetTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/2/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class ObservationSetTests: XCTestCase {
    
    private var observationSet: ObservationSet!
    private var node1: ObservationNode!
    private var node2: ObservationNode!
    private var node3: ObservationNode!
    private var node4: ObservationNode!
    
    override func setUp() {
        observationSet = ObservationSet()
        node1 = ObservationNode(payload: "0", position: simd_double2(x: 1, y: 2), width: 1, height: 1)
        node2 = ObservationNode(payload: "2", position: simd_double2(x: 0, y: 2), width: 0.9, height: 0.8)
        node3 = ObservationNode(payload: "3", position: simd_double2(x: 0, y: 1), width: -1, height: -0.9)
        node4 = ObservationNode(payload: "5", position: simd_double2(x: 1, y: 1), width: 0.5, height: 0.5)
        
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
    }
    
    //MARK: averageNodeDiagonal
    func testAverageNodeDiagonal() {
        //Act & Assert
        XCTAssertEqual(observationSet.averageNodeDiagonal, 1.16771, accuracy: 0.000001)
    }
    
    func testAverageNodeDiagonal_NoNodes() {
        //Arrange
        let observationSet = ObservationSet()
        
        //Act & Assert
        XCTAssertEqual(observationSet.averageNodeDiagonal, 0)
    }
    
    //MARK: add
    func testAdd_NewNode() {
        //Arrange
        let newNode = ObservationNode(payload: "3", position: simd_double2(3, 2), width: 1, height: 1)
        
        //Act
        observationSet.add(newNode)
        
        //Assert
        XCTAssertEqual(observationSet.nodes.count, 5)
        XCTAssertTrue(observationSet.nodes.contains(newNode))
    }
    
    func testAdd_OverLapDifferentCode() {
        //Arrange
        let newNode = ObservationNode(payload: "4", position: simd_double2(1, 2), width: 1, height: 1)
        
        //Act
        observationSet.add(newNode)
        
        //Assert
        XCTAssertEqual(observationSet.nodes.count, 5)
        XCTAssertTrue(observationSet.nodes.contains(newNode))
    }
    
    func testAdd_DuplicateNode() {
        //Arrange
        let newNode = ObservationNode(payload: "0", position: simd_double2(1.4, 1.6), width: 1, height: 1)
        
        //Act
        observationSet.add(newNode)
        
        //Assert
        XCTAssertEqual(observationSet.nodes.count, 4)
        XCTAssertTrue(observationSet.nodes.contains(newNode))
        XCTAssertFalse(observationSet.nodes.contains(node1))
    }
    
    //MARK: markIteration
    func testMarkIteration_NodesRemoved() {
        //Act
        for _ in 0..<14 {
            observationSet.markIteration()
        }
        
        //Assert
        XCTAssertEqual(observationSet.nodes.count, 4)
        
        //Act
        observationSet.markIteration()
        
        //Assert
        XCTAssertEqual(observationSet.nodes.count, 0)
    }
    
    func testMarkIteration_NodeUpdated() {
        //Arrange
        for _ in 0..<14 {
            observationSet.markIteration()
        }
        
        //Act
        let newNode = ObservationNode(payload: "0", position: simd_double2(x: 1, y: 2), width: 1, height: 1)
        observationSet.add(newNode)
        
        //Assert
        XCTAssertEqual(observationSet.nodes.count, 4)
        XCTAssertTrue(observationSet.nodes.contains(newNode))
        
        //Act
        observationSet.markIteration()
        
        //Assert
        XCTAssertEqual(observationSet.nodes.count, 1)
        XCTAssertTrue(observationSet.nodes.contains(newNode))
    }
}
