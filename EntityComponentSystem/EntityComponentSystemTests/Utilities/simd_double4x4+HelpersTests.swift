//
//  simd_double4x4+HelpersTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import EntityComponentSystem

class simd_double4x4_HelpersTests: XCTestCase {

    func testMakeFromTR() {
        //Act
        let translation = simd_double3(2, 4, -1.7)
        let rotation = simd_quatd(angle: -Double.pi / 3, axis: simd_double3(1, -7, 3.6))
        let result = simd_double4x4(translation: translation, rotation: rotation)

        //Assert
        XCTAssertTrue(vectEqual(result.translation, translation, tolerance: 0.000001))
        XCTAssertTrue(quatEqual(result.rotation, rotation, tolerance: 0.000001))
    }
}
