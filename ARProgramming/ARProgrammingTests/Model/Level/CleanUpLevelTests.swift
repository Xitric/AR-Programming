//
//  CleanupLevelTests.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 03/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ARProgramming

class CleanUpLevelTests: XCTestCase {
    
    private var level: CleanUpLevel!
    private var entityManager: EntityManager!
    private var inventoryEntities: [Entity]!
    private var itemEntities: [Entity]!
    private var blueItem1: Entity!
    private var greenItem1: Entity!
    private var greenItem2: Entity!
    private var greenItem3: Entity!
    private var redItem1: Entity!
    private var redItem2: Entity!
    private var yellowItem1: Entity!
    
    override func setUp() {
        level = SimpleLevelLoader.loadLevel(ofType: CleanUpLevel.self, withName: "TestCleanUpLevel.json")
        entityManager = level.entityManager
        inventoryEntities = entityManager.getEntities(withComponents: InventoryComponent.self)
        itemEntities = entityManager.getEntities(withComponents: QuantityComponent.self)
        
        blueItem1 = itemEntities[0]     //-1,0
        greenItem1 = itemEntities[1]    //1,0
        greenItem2 = itemEntities[2]    //0,-1
        greenItem3 = itemEntities[3]    //0,-2
        redItem1 = itemEntities[4]      //0,1
        redItem2 = itemEntities[5]      //-2,0
        yellowItem1 = itemEntities[6]   //2,0
    }
    
    //MARK: init
    func testInit() {
        //Arrange
        let greyInventory = ["Rød":0,"Grøn":0,"Blå":0,"Gul":0]
        let greenInventory = ["Grøn":0]
        
        //Act
        let greyDropSpot = inventoryEntities.first?.component(ofType: InventoryComponent.self) // 0,0
        let greenDropSpot = inventoryEntities.last?.component(ofType: InventoryComponent.self) // 0,2
        
        //Asert
        XCTAssertEqual(greyDropSpot?.quantities, greyInventory)
        XCTAssertEqual(greenDropSpot?.quantities, greenInventory)
        XCTAssertEqual(inventoryEntities.count, 2)
        XCTAssertEqual(itemEntities.count, 7)
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 0 / 1\nGrøn 0 / 1\nGrøn 0 / 2\nGul 0 / 10\nRød 0 / 3")
    }
    
    //MARK: level
    func testLevelCompleted() {
    
        //Act
        moveItem(item: blueItem1, x: 1, y: 0, z: 0)
        
        //Assert
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 1 / 1\nGrøn 0 / 1\nGrøn 0 / 2\nGul 0 / 10\nRød 0 / 3")
        XCTAssertEqual(level.isComplete(), false)
        
        //Act
        moveItem(item: greenItem1, x: -1, y: 0, z: 0)
        
        //Assert
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 1 / 1\nGrøn 0 / 1\nGrøn 1 / 2\nGul 0 / 10\nRød 0 / 3")
        XCTAssertEqual(level.isComplete(), false)
        
        //Act
        moveItem(item: greenItem2, x: 0, y: 0, z: 3)
        
        //Assert
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 1 / 1\nGrøn 1 / 1\nGrøn 1 / 2\nGul 0 / 10\nRød 0 / 3")
        XCTAssertEqual(level.isComplete(), false)
        
        //Act
        moveItem(item: greenItem3, x: 0, y: 0, z: 2)
        
        //Assert
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 1 / 1\nGrøn 1 / 1\nGrøn 2 / 2\nGul 0 / 10\nRød 0 / 3")
        XCTAssertEqual(level.isComplete(), false)
        
        //Act
        moveItem(item: redItem1, x: 0, y: 0, z: -1)
        
        //Assert
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 1 / 1\nGrøn 1 / 1\nGrøn 2 / 2\nGul 0 / 10\nRød 1 / 3")
        XCTAssertEqual(level.isComplete(), false)
        
        //Act
        moveItem(item: redItem2, x: 2, y: 0, z: 0)
        
        //Assert
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 1 / 1\nGrøn 1 / 1\nGrøn 2 / 2\nGul 0 / 10\nRød 3 / 3")
        XCTAssertEqual(level.isComplete(), false)
        
        //Act
        moveItem(item: yellowItem1, x: -2, y: 0, z: 0)
        
        //Assert
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 1 / 1\nGrøn 1 / 1\nGrøn 2 / 2\nGul 10 / 10\nRød 3 / 3")
        XCTAssertEqual(level.isComplete(), true)
    }
   
    func testReset() {
        //Arrange
        moveItem(item: blueItem1, x: 1, y: 1, z: 1)
        moveItem(item: yellowItem1, x: -2, y: 0, z: 0)
        
        //Assert
        XCTAssertEqual(blueItem1.component(subclassOf: TransformComponent.self)?.location, simd_double3(0,1,1))
        XCTAssertEqual(yellowItem1.component(subclassOf: TransformComponent.self)?.location, simd_double3(0,0,0))
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 0 / 1\nGrøn 0 / 1\nGrøn 0 / 2\nGul 10 / 10\nRød 0 / 3")
        XCTAssertEqual(entityManager.getEntities(withComponents: InventoryComponent.self).count, 2)
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 7)
        
        //Act
        level.reset()
        
        //Assert
        XCTAssertEqual(blueItem1.component(subclassOf: TransformComponent.self)?.location, simd_double3(-1,0,0))
        XCTAssertEqual(yellowItem1.component(subclassOf: TransformComponent.self)?.location, simd_double3(2,0,0))
        XCTAssertEqual(level.infoLabel, "Sæt tingene på plads\nBlå 0 / 1\nGrøn 0 / 1\nGrøn 0 / 2\nGul 0 / 10\nRød 0 / 3")
        XCTAssertEqual(entityManager.getEntities(withComponents: InventoryComponent.self).count, 2)
        XCTAssertEqual(entityManager.getEntities(withComponents: QuantityComponent.self).count, 7)
    }
    
    private func moveItem(item: Entity, x: Double, y: Double, z: Double){
        item.component(subclassOf: TransformComponent.self)?.location += simd_double3(x,y,z)
        level.update(delta: 1)
    }
}
