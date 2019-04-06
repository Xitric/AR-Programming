//
//  LevelTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ARProgramming

class LevelTests: XCTestCase {

    private var level: LevelMock!
    private var entityManager: EntityManager!
    
    override func setUp() {
        entityManager = EntityManager()
        level = LevelMock(expectedDelta: 5, entityManager: entityManager)
    }
    
    //MARK: init
    func testInit() {
        //Act
        level = SimpleLevelLoader.loadLevel(ofType: LevelMock.self, withName: "TestLevel.json")
        
        //Assert
        XCTAssertNotNil(level)
        XCTAssertEqual(level?.levelType, "quantity")
        XCTAssertEqual(level?.name, "Test Level")
        XCTAssertEqual(level?.levelNumber, 0)
        XCTAssertEqual(level?.unlocked, false)
        XCTAssertEqual(level?.unlocks, "TestUnlockLevel")
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
    
    //MARK: reset
    func testReset() {
        //Arrange
        let playerTransform = entityManager.player.component(subclassOf: TransformComponent.self)!
        
        playerTransform.location = simd_double3(2, 4, -9)
        playerTransform.rotation = simd_quatd(ix: 0, iy: -0.707, iz: 0, r: 0.707)
        
        //Act
        level.reset()
        
        //Assert
        XCTAssertTrue(vectEqual(playerTransform.location, simd_double3(0, 0, 0), tolerance: 0.000001))
        XCTAssertTrue(quatEqual(playerTransform.rotation, simd_quatd(ix: 0, iy: 0, iz: 0, r: 1), tolerance: 0.000001))
    }
}

class LevelMock: Level {
    
    let updateExpectation: XCTestExpectation!
    var expectedDelta = 0.0
    
    init(expectedDelta: Double, entityManager: EntityManager) {
        updateExpectation = XCTestExpectation(description: "Update with delta called")
        self.expectedDelta = expectedDelta
        super.init(levelType: "TestLevel", name: "Test Level", levelNumber: -1, unlocked: true, unlocks: nil)
        self.entityManager = entityManager
    }
    
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
