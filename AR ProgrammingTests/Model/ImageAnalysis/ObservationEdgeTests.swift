//
//  ObservationEdgeTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/2/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class ObservationEdgeTests: XCTestCase {

    func testCorrectedAngleTo() {
        //Arrange
        let topBranchInbound = ObservationEdge(predecessor: ObservationNode(code: 0, position: simd_double2(-1, -1)), successor: ObservationNode(code: 0, position: simd_double2(0, 0)), connectionAngle: 0.785)
        let bottomBranchInbound = ObservationEdge(predecessor: ObservationNode(code: 0, position: simd_double2(-1, 1)), successor: ObservationNode(code: 0, position: simd_double2(0, 0)), connectionAngle: -0.785)
        let simpleInbound = ObservationEdge(predecessor: ObservationNode(code: 0, position: simd_double2(-1, 0)), successor: ObservationNode(code: 0, position: simd_double2(0, 0)), connectionAngle: 0)
        
        let topBranchOutbound = ObservationEdge(predecessor: ObservationNode(code: 0, position: simd_double2(0, 0)), successor: ObservationNode(code: 0, position: simd_double2(1, 1)), connectionAngle: 0.785)
        let bottomBranchOutbound = ObservationEdge(predecessor: ObservationNode(code: 0, position: simd_double2(0, 0)), successor: ObservationNode(code: 0, position: simd_double2(1, -1)), connectionAngle: -0.785)
        let simpleOutbound = ObservationEdge(predecessor: ObservationNode(code: 0, position: simd_double2(0, 0)), successor: ObservationNode(code: 0, position: simd_double2(1, 0)), connectionAngle: 0)
        
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
}
