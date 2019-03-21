//
//  QuantityLevelTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import AR_Programming

class QuantityLevelTests: XCTestCase {
    
    private var level: QuantityLevel!
    private var entityManager: EntityManager!
    private var playerQuantity: QuantityComponent!
    
    override func setUp() {
        level = (try? LevelManager.loadLevel(byName: "Level3")) as? QuantityLevel
        entityManager = level.entityManager
        playerQuantity = entityManager.player.component(ofType: QuantityComponent.self)
    }

    //MARK: infoLabel
    func testQuantityLabel() {
        //Arrange
        playerQuantity.quantity = 3
        
        //Act
        let label = level.infoLabel
        
        //Assert
        XCTAssertNotNil(label)
        XCTAssertTrue(label!.contains("3/6"))
    }
    
    func testQuantityLabel_Exceeded() {
        //Arrange
        playerQuantity.quantity = 8
        
        //Act
        let label = level.infoLabel
        
        //Assert
        XCTAssertNotNil(label)
        XCTAssertTrue(label!.contains("det er for meget"))
    }
    
    //MARK: update
    func testUpdate() {
        //Arrange
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 5)
        if let playerTransform = entityManager.player.component(subclassOf: TransformComponent.self) {
            playerTransform.location += simd_double3(1, 0, 0)
        } else {
            XCTFail()
        }
        
        //Act
        level.update(currentTime: 2)
        
        //Assert
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 4)
        XCTAssertEqual(entityManager.player.component(ofType: QuantityComponent.self)?.quantity, 2)
    }
    
    //MARK: reset
    func testReset() {
        //Arrange
        playerQuantity.quantity = 3
        let collectibles = entityManager.getEntities(withComponents: QuantityComponent.self).filter {
            $0 !== entityManager.player
        }
        entityManager.removeEntity(collectibles[0])
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 4)
        
        //Act
        level.reset()
        
        //Assert
        XCTAssertEqual(playerQuantity.quantity, 0)
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 5)
    }
}
