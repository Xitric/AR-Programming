//
//  WardrobeManagerTests.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import ARProgramming

class WardrobeManagerTests: XCTestCase {

    // MARK: setRobotChoice
    func testSetRobotChoice() {
        //Arrange
        let blueRobotFile = "blueBot"
        let greenRobotFile = "greenBot"

        let blueExpectation = expectation(description: "Blue robot was chosen")
        let greenExpectation = expectation(description: "Green robot was chosen")

        let wardrobe = WardrobeManager(context: CoreDataRepository())

        //Act
        wardrobe.setRobotChoice(choice: blueRobotFile) {
            blueExpectation.fulfill()
        }

        //Assert
        wait(for: [blueExpectation], timeout: 1)
        XCTAssertTrue(wardrobe.selectedRobotSkin() == blueRobotFile)

        //Act
        wardrobe.setRobotChoice(choice: greenRobotFile) {
            greenExpectation.fulfill()
        }

        //Assert
        wait(for: [greenExpectation], timeout: 1)
        XCTAssertTrue(wardrobe.selectedRobotSkin() == greenRobotFile)
    }
}
