//
//  ObservationGraphTests.swift
//  VisionCardTestTests
//
//  Created by user143563 on 2/2/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class ObservationGraphTests: XCTestCase {
    
    private var graph: ObservationGraph!
    private var node1: ObservationNode!
    private var node2: ObservationNode!
    private var node3: ObservationNode!
    private var node4: ObservationNode!
    private var node5: ObservationNode!
    private var node6: ObservationNode!
    private var node7: ObservationNode!
    private var node8: ObservationNode!
    
    // Layout by card number:
    //
    //   |6| |2|
    // |7|5|1|3|   |8|
    //       |4|
    //
    override func setUp() {
        node1 = ObservationNode(code: 5, position: simd_double2(1, 0))
        node2 = ObservationNode(code: 3, position: simd_double2(2, 1))
        node3 = ObservationNode(code: 0, position: simd_double2(2, 0))
        node4 = ObservationNode(code: 2, position: simd_double2(2, -1))
        node5 = ObservationNode(code: 0, position: simd_double2(0, 0))
        node6 = ObservationNode(code: 0, position: simd_double2(0, 1))
        node7 = ObservationNode(code: 1, position: simd_double2(-1, 0))
        node8 = ObservationNode(code: 4, position: simd_double2(5, 0))
        
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
        graph.connect(from: node2, to: node3, with: -Double.pi/2)
        graph.connect(from: node3, to: node4, with: -Double.pi/2)
    }
    
    func testFirstObservation() {
        //Act & Assert
        XCTAssertEqual(graph.firstObservation(with: 3), node2)
        XCTAssertTrue([node3, node5, node6].contains(graph.firstObservation(with: 0)))
        XCTAssertNil(graph.firstObservation(with: 9))
    }
    
    func testObservationsNear_OnlyOthers() {
        //Act
        let result = graph.observations(near: node1)
        
        //Assert
        XCTAssertFalse(result.contains(node1))
    }
    
    func testObservationsNear_NoConnected() {
        //Act
        let result = graph.observations(near: node1)
        
        //Assert
        XCTAssertFalse(result.contains(node2))
        XCTAssertFalse(result.contains(node3))
        XCTAssertFalse(result.contains(node4))
    }
    
    func testObservationsNear_OnlyClose() {
        //Act
        let result = graph.observations(near: node1)
        
        //Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains(node5))
        XCTAssertTrue(result.contains(node6))
        XCTAssertFalse(result.contains(node7))
    }
    
    func testObservationsNear_FromChain() {
        //Act
        let result = graph.observations(near: node3)
        
        //Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.contains(node1))
    }
    
    func testConnect() {
        //Act
        graph.connect(from: node6, to: node5, with: -Double.pi/2)
        graph.connect(from: node5, to: node7, with: Double.pi)
        graph.connect(from: node5, to: node1, with: 0)
        graph.connect(from: node1, to: node2, with: -Double.pi/4)
        
        //Assert
        XCTAssertNil(node6.parent)
        XCTAssertEqual(node5.parent, node6)
        XCTAssertEqual(node7.parent, node5)
        XCTAssertEqual(node1.parent, node5)
        XCTAssertEqual(node2.parent, node1)
        XCTAssertEqual(node3.parent, node2)
        XCTAssertEqual(node4.parent, node3)
        
        assertEdge(from: node6, to: node5, withAngle: -Double.pi/2)
        assertEdge(from: node5, to: node7, withAngle: Double.pi)
        assertEdge(from: node5, to: node1, withAngle: 0)
        assertEdge(from: node1, to: node2, withAngle: -Double.pi/4)
        assertEdge(from: node2, to: node3, withAngle: -Double.pi/2)
        assertEdge(from: node3, to: node4, withAngle: -Double.pi/2)
    }
    
    private func assertEdge(from predecessor: ObservationNode, to successor: ObservationNode, withAngle angle: Double) {
        let edge = graph.edge(from: predecessor, to: successor)
        XCTAssertNotNil(edge)
        XCTAssertEqual(edge!.predecessor, predecessor)
        XCTAssertEqual(edge!.successor, successor)
        XCTAssertEqual(edge!.connectionAngle, angle)
    }
    
    func testEdge() {
        //Arrange
        graph.connect(from: node2, to: node1, with: -3 * Double.pi / 4)
        
        //Act & Assert
        XCTAssertNotNil(graph.edge(from: node2, to: node1))
        XCTAssertNotNil(graph.edge(from: node2, to: node3))
        XCTAssertNotNil(graph.edge(from: node3, to: node4))
        XCTAssertNil(graph.edge(from: node1, to: node2))
        XCTAssertNil(graph.edge(from: node2, to: node5))
        XCTAssertNil(graph.edge(from: node5, to: node7))
    }
    
    func testGetSuccessor_OnLine() {
        //Arrange
        graph.connect(from: node6, to: node5, with: -Double.pi / 2)
        
        //Act
        let result = graph.getSuccessor(by: 0, to: node5)
        
        //Assert
        XCTAssertEqual(node1, result)
    }
    
    func testGetSuccessor_Above() {
        //Arrange
        graph.connect(from: node7, to: node5, with: 0)
        
        //Act
        let result = graph.getSuccessor(by: Double.pi / 2, to: node5)
        
        //Assert
        XCTAssertEqual(node6, result)
    }
    
    func testGetSuccessor_ImpreciseAngle() {
        //Arrange
        graph.connect(from: node7, to: node5, with: 0)
        
        //Act
        let result = graph.getSuccessor(by: 0.3, to: node5)
        
        //Assert
        XCTAssertEqual(node1, result)
    }
    
    func testGetSuccessor_NoNeighborsNearby() {
        //Act
        let result = graph.getSuccessor(by: Double.pi, to: node8)
        
        //Assert
        XCTAssertNil(result)
    }
    
    func testGetSuccessor_NoNeighborAtAngle() {
        //Arrange
        graph.connect(from: node7, to: node5, with: 0)
        
        //Act
        let result = graph.getSuccessor(by: -Double.pi / 2, to: node5)
        
        //Assert
        XCTAssertNil(result)
    }
    
    func testGetSuccessor_NoParent() {
        //Act
        let result = graph.getSuccessor(by: 0, to: node5)
        
        //Assert
        XCTAssertEqual(node1, result)
    }
}
