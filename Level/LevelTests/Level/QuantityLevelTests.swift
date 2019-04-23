//
//  QuantityLevelTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import Level

class QuantityLevelTests: XCTestCase {
    
    private var level: QuantityLevel!
    private var entityManager: EntityManager!
    private var playerInventory: InventoryComponent!
    
    override func setUp() {
        level = SimpleLevelLoader.loadLevel(ofType: QuantityLevel.self, withName: "TestLevel.json")
        entityManager = level.entityManager
        playerInventory = entityManager.player.component(ofType: InventoryComponent.self)
    }
    
    //MARK: infoLabel
    func testInfoLabel() {
        //Arrange
        playerInventory.add(quantity: 3, ofType: "mønter")
        
        //Act
        let label = level.infoLabel
        
        //Assert
        XCTAssertEqual(label, "Du har samlet 3/7 mønter. Du skal undgå rubiner.")
        XCTAssertFalse(level.isComplete())
    }
    
    func testInfoLabel_Exceeded() {
        //Arrange
        playerInventory.add(quantity: 8, ofType: "mønter")
        
        //Act
        let label = level.infoLabel
        
        //Assert
        XCTAssertEqual(label, "Du har samlet for meget!")
        XCTAssertFalse(level.isComplete())
    }
    
    func testInfoLabel_IllegalItem() {
        //Arrange
        playerInventory.add(quantity: 1, ofType: "rubiner")
        
        //Act
        let label = level.infoLabel
        
        //Assert
        XCTAssertEqual(label, "Du har samlet noget, du ikke måtte samle!")
        XCTAssertFalse(level.isComplete())
    }
    
    func testInfoLabel_Done() {
        //Arrange
        playerInventory.add(quantity: 7, ofType: "mønter")
        
        //Act
        let label = level.infoLabel
        
        //Assert
        XCTAssertNil(label)
        XCTAssertTrue(level.isComplete())
    }
    
    //MARK: init
    func testInit() {
        let entities = level?.entityManager.getEntities(withComponents: TransformComponent.self)
        XCTAssertEqual(entities?.count, 11)
        
        let collectibles = level?.entityManager.getEntities(withComponents: QuantityComponent.self)
        XCTAssertEqual(collectibles?.count, 8)
    }
    
    //MARK: update
    func testUpdate() {
        //Arrange
        let delegate = LevelDelegateMock()
        level.delegate = delegate
        
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 8)
        if let playerTransform = entityManager.player.component(subclassOf: TransformComponent.self) {
            playerTransform.location += simd_double3(1, 0, 0)
        } else {
            XCTFail()
        }
        
        //Act
        level.update(currentTime: 2)
        
        //Assert
        wait(for: [delegate.infoExpectation], timeout: 1)
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 7)
        XCTAssertEqual(playerInventory.quantities["rubiner"], 1)
    }
    
    func testUpdate_CompleteLevel() {
        //Arrange
        let delegate = LevelDelegateMock()
        level.delegate = delegate
        playerInventory.add(quantity: 6, ofType: "mønter")
        if let playerTransform = entityManager.player.component(subclassOf: TransformComponent.self) {
            playerTransform.location += simd_double3(0, 0, 1)
        } else {
            XCTFail()
        }
        
        //Act
        level.update(delta: 2)
        
        //Assert
        wait(for: [delegate.infoExpectation], timeout: 1)
        wait(for: [delegate.completionExpectation], timeout: 1)
        XCTAssertTrue(level.isComplete())
    }
}

class LevelDelegateMock: LevelDelegate {
    
    let completionExpectation: XCTestExpectation
    let resetExpectation: XCTestExpectation
    let infoExpectation: XCTestExpectation
    
    init() {
        completionExpectation = XCTestExpectation(description: "Completion called")
        resetExpectation = XCTestExpectation(description: "Reset called")
        infoExpectation = XCTestExpectation(description: "Info changed")
    }
    
    func levelCompleted(_ level: LevelProtocol) {
        completionExpectation.fulfill()
    }
    
    func levelReset(_ level: LevelProtocol) {
        resetExpectation.fulfill()
    }
    
    func levelInfoChanged(_ level: LevelProtocol, info: String?) {
        infoExpectation.fulfill()
    }
}
