//
//  WardrobeManagerTests.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import AR_Programming

class WardrobeManagerTests: XCTestCase {
    
    //MARK: robotChoice
    func testSetRobotChoice() {
        //Arrange
        let robotFile1 = "blueBot"
        let robotFile2 = "greenBot"
        let group = DispatchGroup()
        
        //Act
        group.enter()
        DispatchQueue.main.async {
            WardrobeManager.setRobotChoice(choice: robotFile1)
            group.leave()
        }
        
        //Assert
        group.enter()
        group.notify(queue: .main) {
            XCTAssertTrue(WardrobeManager.robotChoice() == robotFile1)
            group.leave()
        }
        
        //Act
        group.enter()
        DispatchQueue.main.async {
            WardrobeManager.setRobotChoice(choice: robotFile2)
            group.leave()
        }
        
        //Assert
        group.enter()
        group.notify(queue: .main) {
            XCTAssertTrue(WardrobeManager.robotChoice() == robotFile2)
            group.leave()
        }
    }
    
}
