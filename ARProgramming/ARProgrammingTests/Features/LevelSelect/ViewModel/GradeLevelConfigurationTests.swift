//
//  GradeLevelConfigurationTests.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 08/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Level
@testable import ARProgramming

class GradeLevelConfigurationTests: XCTestCase {

    private var levelConfig: LevelConfig!

    override func setUp() {
        levelConfig = LevelConfig()
    }

    func testLevelsForGrade_1() {
        // Arrange
        let expectedLevels = [1, 2, 3, 4, 5, 6, 7]

        // Act
        let actualLevels = levelConfig.levels(forGrade: 1)

        // Assert
        XCTAssertEqual(expectedLevels, actualLevels)
    }

    func testLevelsForGrade_2() {
        // Arrange
        let expectedLevels = [8]

        // Act
        let actualLevels = levelConfig.levels(forGrade: 2)

        // Assert
        XCTAssertEqual(expectedLevels, actualLevels)
    }

    func testLevelsForGrade_3() {
        // Arrange
        let expectedLevels = [9, 10, 11, 12, 13, 14]

        // Act
        let actualLevels = levelConfig.levels(forGrade: 3)

        // Assert
        XCTAssertEqual(expectedLevels, actualLevels)
    }

    func testLevelsForGrade_4() {
        // Arrange
        let expectedLevels = [15, 16]

        // Act
        let actualLevels = levelConfig.levels(forGrade: 4)

        // Assert
        XCTAssertEqual(expectedLevels, actualLevels)
    }

    func testLevelsForGrade_invalid() {
        // Arrange
        let expectedLevels: [Int] = []

        // Act
        let actualLevels = levelConfig.levels(forGrade: -1)

        // Assert
        XCTAssertEqual(expectedLevels, actualLevels)
    }
}
