//
//  LevelTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import Level

class LevelTests: XCTestCase {

    private var level: LevelMock!
    
    override func setUp() {
        level = SimpleLevelLoader.loadLevel(ofType: LevelMock.self, withName: "TestLevel.json")
        level.expectedDelta = 5
    }
    
    //MARK: init
    func testInit() {
        //Assert
        XCTAssertNotNil(level)
        XCTAssertEqual(level?.levelType, "quantity")
        XCTAssertEqual(level?.name, "Test Level")
        XCTAssertEqual(level?.levelNumber, 0)
        XCTAssertEqual(level?.unlocked, false)
        XCTAssertEqual(level?.unlocks, 5)
        XCTAssertNil(level!.infoLabel)
        
        let entities = level?.entityManager.getEntities(withComponents: TransformComponent.self)
        XCTAssertEqual(entities?.count, 3)
        
        let props = entities?.filter {
            $0 !== level?.entityManager.player
        }
        XCTAssertEqual(props?.count, 2)
    }

    //MARK: update
    func testUpdate() {
        //Act
        level.update(currentTime: 5)
        
        //Assert
        wait(for: [level.updateExpectation], timeout: 1)
    }
    
    func testUpdate_SecondTime() {
        //Arrange
        level.update(currentTime: 10)
        
        //Act
        level.update(currentTime: 15)
        
        //Assert
        wait(for: [level.updateExpectation], timeout: 1)
    }
}

class LevelMock: Level {
    
    let updateExpectation: XCTestExpectation!
    var expectedDelta = 0.0
    
    required init(from decoder: Decoder) throws {
        updateExpectation = XCTestExpectation(description: "Update with delta called")
        try super.init(from: decoder)
    }
    
    override func update(delta: TimeInterval) {
        if delta == expectedDelta {
            updateExpectation.fulfill()
        }
    }
}
