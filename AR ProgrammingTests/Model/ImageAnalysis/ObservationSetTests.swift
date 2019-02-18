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
    
    override func setUp() {
        observationSet = ObservationSet()
    }
    
    func testUniquifyNoRemovals() {
        //Arrange
        let node1 = ObservationNode(code: 0, position: simd_double2(0, 0))
        let node2 = ObservationNode(code: 0, position: simd_double2(0, 0.5))
        let node3 = ObservationNode(code: 0, position: simd_double2(5, 6))
        let node4 = ObservationNode(code: 0, position: simd_double2(-2, -9))
        
        //Act
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
        observationSet.uniquify(accordingTo: 1)
        
        //Assert
        XCTAssertEqual(observationSet.observations.count, 4)
        XCTAssertTrue(observationSet.observations.contains(node1))
        XCTAssertTrue(observationSet.observations.contains(node2))
        XCTAssertTrue(observationSet.observations.contains(node3))
        XCTAssertTrue(observationSet.observations.contains(node4))
    }
    
    func testUniquifyDuplicates() {
        //Arrange
        let node1 = ObservationNode(code: 0, position: simd_double2(0, 0))
        let node2 = ObservationNode(code: 0, position: simd_double2(0.2, -0.2))
        let node3 = ObservationNode(code: 0, position: simd_double2(5, 6))
        
        //Act
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.uniquify(accordingTo: 1)
        
        //Assert
        XCTAssertEqual(observationSet.observations.count, 2)
        XCTAssertTrue(observationSet.observations.contains(node1))
        XCTAssertTrue(observationSet.observations.contains(node3))
    }
}
