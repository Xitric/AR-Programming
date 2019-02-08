//
//  Double+HelpersTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/2/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import AR_Programming

class Double_HelpersTests: XCTestCase {

    func testIsEqualWithMargin() {
        XCTAssertTrue(0.isEqual(to: 0, margin: 0))
        XCTAssertTrue(0.isEqual(to: 0.5, margin: 0.5))
        XCTAssertTrue(0.5.isEqual(to: 0, margin: 0.5))
        XCTAssertTrue((-1).isEqual(to: 1, margin: 2))
        XCTAssertTrue((-2).isEqual(to: 0, margin: 2))
        XCTAssertTrue(1.isEqual(to: -1, margin: 2))
        XCTAssertTrue(1.isEqual(to: 1, margin: -5))
        
        XCTAssertFalse(0.isEqual(to: 1, margin: 0.5))
        XCTAssertFalse(1.isEqual(to: 2, margin: -5))
    }
}
