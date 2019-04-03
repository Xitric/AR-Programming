//
//  ObservationGraphTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/2/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
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
        node1 = ObservationNode(payload: "5", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        node2 = ObservationNode(payload: "3", position: simd_double2(2, 1), width: 0.8, height: 0.8)
        node3 = ObservationNode(payload: "0", position: simd_double2(2, 0), width: 0.8, height: 0.8)
        node4 = ObservationNode(payload: "2", position: simd_double2(2, -1), width: 0.8, height: 0.8)
        node5 = ObservationNode(payload: "0", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        node6 = ObservationNode(payload: "0", position: simd_double2(0, 1), width: 0.8, height: 0.8)
        node7 = ObservationNode(payload: "1", position: simd_double2(-1, 0), width: 0.8, height: 0.8)
        node8 = ObservationNode(payload: "4", position: simd_double2(5, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
        observationSet.add(node5)
        observationSet.add(node6)
        observationSet.add(node7)
        
        graph = ObservationGraph(observationSet: observationSet)
        graph.connect(from: node2, to: node3, withAngle: -Double.pi/2)
        graph.connect(from: node3, to: node4, withAngle: -Double.pi/2)
    }
    
    //MARK: firstNode
    func testFirstNodeWithPayloadIn() {
        //Act & Assert
        XCTAssertEqual(graph.firstNode(withPayloadIn: ["3"]), node2)
        XCTAssertTrue([node3, node5, node6].contains(graph.firstNode(withPayloadIn: ["0"])))
        XCTAssertNil(graph.firstNode(withPayloadIn: ["9"]))
        
        XCTAssertEqual(graph.firstNode(withPayloadIn: ["9", "3"]), node2)
        XCTAssertTrue([node1, node2, node4].contains(graph.firstNode(withPayloadIn: ["2", "5", "3"])))
        XCTAssertNil(graph.firstNode(withPayloadIn: ["10", "20", "30"]))
    }
    
    //MARK: nodes
    func testNodesNear_OnlyOthers() {
        //Act
        let result = graph.nodes(near: node1)
        
        //Assert
        XCTAssertFalse(result.contains(node1))
    }
    
    func testNodesNear_NoConnected() {
        //Act
        let result = graph.nodes(near: node1)
        
        //Assert
        XCTAssertFalse(result.contains(node2))
        XCTAssertFalse(result.contains(node3))
        XCTAssertFalse(result.contains(node4))
    }
    
    func testNodesNear_OnlyClose() {
        //Act
        let result = graph.nodes(near: node1)
        
        //Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains(node5))
        XCTAssertTrue(result.contains(node6))
        XCTAssertFalse(result.contains(node7))
    }
    
    func testNodesNear_FromChain() {
        //Act
        let result = graph.nodes(near: node3)
        
        //Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.contains(node1))
    }
    
    //MARK: connect
    func testConnect() {
        //Act
        graph.connect(from: node6, to: node5, withAngle: -Double.pi/2)
        graph.connect(from: node5, to: node7, withAngle: Double.pi)
        graph.connect(from: node5, to: node1, withAngle: 0)
        graph.connect(from: node1, to: node2, withAngle: -Double.pi/4)
        
        //Assert
        XCTAssertEqual(graph.nodes(near: node5).count, 0)
        
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
    
    //MARK: edge
    func testEdge() {
        //Arrange
        graph.connect(from: node2, to: node1, withAngle: -3 * Double.pi / 4)
        
        //Act & Assert
        XCTAssertNotNil(graph.edge(from: node2, to: node1))
        XCTAssertNotNil(graph.edge(from: node2, to: node3))
        XCTAssertNotNil(graph.edge(from: node3, to: node4))
        XCTAssertNil(graph.edge(from: node1, to: node2))
        XCTAssertNil(graph.edge(from: node2, to: node5))
        XCTAssertNil(graph.edge(from: node5, to: node7))
    }
    
    //MARK: getSuccessor
    func testGetSuccessor_OnLine() {
        //Arrange
        graph.connect(from: node6, to: node5, withAngle: -Double.pi / 2)
        
        //Act
        let result = graph.getSuccessor(by: 0, to: node5)
        
        //Assert
        XCTAssertEqual(node1, result)
    }
    
    func testGetSuccessor_Above() {
        //Arrange
        graph.connect(from: node7, to: node5, withAngle: 0)
        
        //Act
        let result = graph.getSuccessor(by: Double.pi / 2, to: node5)
        
        //Assert
        XCTAssertEqual(node6, result)
    }
    
    func testGetSuccessor_ImpreciseAngle() {
        //Arrange
        graph.connect(from: node7, to: node5, withAngle: 0)
        
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
        graph.connect(from: node7, to: node5, withAngle: 0)
        
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
