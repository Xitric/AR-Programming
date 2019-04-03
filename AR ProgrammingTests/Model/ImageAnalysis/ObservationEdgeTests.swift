//
//  ObservationEdgeTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/2/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
import Vision
@testable import AR_Programming

class ObservationEdgeTests: XCTestCase {

    //MARK: correctedAngleTo
    func testCorrectedAngleTo() {
        //Arrange
        let topBranchInbound = ObservationEdge(predecessor: createObservationNode(-1, -1),
                                               successor: createObservationNode(0, 0), connectionAngle: Double.pi/4)
        let bottomBranchInbound = ObservationEdge(predecessor: createObservationNode(-1, 1),
                                                  successor: createObservationNode(0, 0), connectionAngle: -Double.pi/4)
        let simpleInbound = ObservationEdge(predecessor: createObservationNode(-1, 0),
                                            successor: createObservationNode(0, 0), connectionAngle: 0)
        
        let topBranchOutbound = ObservationEdge(predecessor: createObservationNode(0, 0),
                                                successor: createObservationNode(1, 1), connectionAngle: Double.pi/4)
        let bottomBranchOutbound = ObservationEdge(predecessor: createObservationNode(0, 0),
                                                   successor: createObservationNode(1, -1), connectionAngle: -Double.pi/4)
        let simpleOutbound = ObservationEdge(predecessor: createObservationNode(0, 0),
                                             successor: createObservationNode(1, 0), connectionAngle: 0)
        
        //Act & Assert
        XCTAssertEqual(topBranchInbound.correctedAngleTo(edge: topBranchOutbound), 0, accuracy: 0.001)
        XCTAssertEqual(topBranchInbound.correctedAngleTo(edge: bottomBranchOutbound), 0, accuracy: 0.001)
        XCTAssertEqual(topBranchInbound.correctedAngleTo(edge: simpleOutbound), 0, accuracy: 0.001)
        
        XCTAssertEqual(bottomBranchInbound.correctedAngleTo(edge: topBranchOutbound), 0, accuracy: 0.001)
        XCTAssertEqual(bottomBranchInbound.correctedAngleTo(edge: bottomBranchOutbound), 0, accuracy: 0.001)
        XCTAssertEqual(bottomBranchInbound.correctedAngleTo(edge: simpleOutbound), 0, accuracy: 0.001)
        
        XCTAssertEqual(simpleInbound.correctedAngleTo(edge: topBranchOutbound), 0, accuracy: 0.001)
        XCTAssertEqual(simpleInbound.correctedAngleTo(edge: bottomBranchOutbound), 0, accuracy: 0.001)
        XCTAssertEqual(simpleInbound.correctedAngleTo(edge: simpleOutbound), 0, accuracy: 0.001)
    }
    
    private func createObservationNode(_ x: Double, _ y: Double) -> ObservationNode {
        return ObservationNode(payload: "0", position: simd_double2(x, y), width: 0, height: 0)
    }
}
