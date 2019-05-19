//
//  ObservationNodeTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 03/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class ObservationNodeTests: XCTestCase {

    // MARK: diagonal
    func testDiagonal() {
        var d = ObservationNode(payload: "0", position: simd_double2(x: 0, y: 0), width: 3, height: 4).diagonal
        XCTAssertEqual(d, 5, accuracy: 0.00001)

        d = ObservationNode(payload: "0", position: simd_double2(x: 0, y: 0), width: 1, height: 1).diagonal
        XCTAssertEqual(d, sqrt(2), accuracy: 0.00001)

        d = ObservationNode(payload: "0", position: simd_double2(x: 0, y: 0), width: 0, height: 4).diagonal
        XCTAssertEqual(d, 4, accuracy: 0.00001)

        d = ObservationNode(payload: "0", position: simd_double2(x: 0, y: 0), width: 5, height: 0).diagonal
        XCTAssertEqual(d, 5, accuracy: 0.00001)

        d = ObservationNode(payload: "0", position: simd_double2(x: 0, y: 0), width: 0, height: 0).diagonal
        XCTAssertEqual(d, 0, accuracy: 0.00001)

        d = ObservationNode(payload: "0", position: simd_double2(x: 0, y: 0), width: -3, height: 4).diagonal
        XCTAssertEqual(d, 5, accuracy: 0.00001)
    }
}
