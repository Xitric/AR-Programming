//
//  EntityManagerTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import GameplayKit
@testable import AR_Programming

class EntityManagerTests: XCTestCase {

    private var entityManager: EntityManager!
    private var entityManagerDelegate: EntityManagerDelegateImpl!
    
    override func setUp() {
        entityManager = EntityManager()
        entityManagerDelegate = EntityManagerDelegateImpl()
        entityManager.delegate = entityManagerDelegate
    }

    //MARK: addEntity
    func testAddEntity() {
        //Arrange
        entityManager.addSystem(GKComponentSystem.init(componentClass: ComponentMock.self))
        let component1 = ComponentMock()
        let entity1 = Entity()
        entity1.addComponent(component1)
        entityManagerDelegate.expect(entity1)
        
        //Act
        entityManager.addEntity(entity1)
        
        //Assert
        wait(for: [entityManagerDelegate.addExpectation], timeout: 1)
        
        //Second entity
        //Arrange
        let component2 = ComponentMock()
        let entity2 = Entity()
        entity2.addComponent(component2)
        entityManagerDelegate.expect(entity2)
        
        //Act
        entityManager.addEntity(entity2)
        
        //Assert
        wait(for: [entityManagerDelegate.addExpectation], timeout: 1)
        entityManager.update(1)
        wait(for: [component1.updateExpectation], timeout: 1)
        wait(for: [component2.updateExpectation], timeout: 1)
    }
    
    func testAddEntity_NoSystem() {
        //Arrange
        let component = ComponentMock()
        component.updateExpectation.isInverted = true
        let entity = Entity()
        entity.addComponent(component)
        
        //Act
        entityManager.addEntity(entity)
        
        //Assert
        wait(for: [component.updateExpectation], timeout: 1)
    }
    
    func testManagerNotifiedOnEntityChanges() {
        //Arrange
        entityManager.addSystem(GKComponentSystem.init(componentClass: ComponentMock.self))
        let entity = Entity()
        entityManager.addEntity(entity)
        
        //Act
        let component = ComponentMock()
        entity.addComponent(component)
        
        //Assert
        entityManager.update(1)
        wait(for: [component.updateExpectation], timeout: 1)
    }
    
    //MARK: removeEntity
    func testRemoveEntity() {
        //Arrange
        entityManager.addSystem(GKComponentSystem.init(componentClass: ComponentMock.self))
        let component = ComponentMock()
        component.updateExpectation.isInverted = true
        let entity = Entity()
        entity.addComponent(component)
        entityManager.addEntity(entity)
        entityManagerDelegate.expect(entity)
        
        //Act
        entityManager.removeEntity(entity)
        
        //Assert
        wait(for: [entityManagerDelegate.removeExpectation], timeout: 1)
        entityManager.update(1)
        wait(for: [component.updateExpectation], timeout: 1)
    }
    
    func testManagerNoLongerNotifiedOnEntityChanges() {
        //Arrange
        entityManager.addSystem(GKComponentSystem.init(componentClass: ComponentMock.self))
        let entity = Entity()
        entityManager.addEntity(entity)
        
        //Act
        entityManager.removeEntity(entity)
        let component = ComponentMock()
        component.updateExpectation.isInverted = true
        entity.addComponent(component)
        
        //Assert
        entityManager.update(1)
        wait(for: [component.updateExpectation], timeout: 1)
    }
    
    //MARK: addSystem
    func testAddSystem_AfterEntities() {
        //Arrange
        let component1 = ComponentMock()
        let entity1 = Entity()
        entity1.addComponent(component1)
        let component2 = ComponentMock()
        let entity2 = Entity()
        entity2.addComponent(component2)
        entityManager.addEntity(entity1)
        entityManager.addEntity(entity2)
        
        //Act
        entityManager.addSystem(GKComponentSystem.init(componentClass: ComponentMock.self))
        
        //Assert
        entityManager.update(1)
        wait(for: [component1.updateExpectation], timeout: 1)
        wait(for: [component2.updateExpectation], timeout: 1)
    }
    
    //MARK: removeSystem
    func testRemoveSystem() {
        //Arrange
        let system = GKComponentSystem.init(componentClass: ComponentMock.self)
        entityManager.addSystem(system)
        let component1 = ComponentMock()
        component1.updateExpectation.isInverted = true
        let entity1 = Entity()
        entity1.addComponent(component1)
        let component2 = ComponentMock()
        component2.updateExpectation.isInverted = true
        let entity2 = Entity()
        entity2.addComponent(component2)
        entityManager.addEntity(entity1)
        entityManager.addEntity(entity2)
        
        //Act
        entityManager.removeSystem(forComponent: ComponentMock.self)
        
        //Assert
        entityManager.update(1)
        wait(for: [component1.updateExpectation], timeout: 1)
        wait(for: [component2.updateExpectation], timeout: 1)
        XCTAssertTrue(system.components.isEmpty)
    }
}

class EntityManagerDelegateImpl: AddRemoveDelegateMock<Entity>, EntityManagerDelegate {
    func entityManager(_ entityManager: EntityManager, added entity: Entity) {
        notify(added: entity)
    }
    
    func entityManager(_ entityManager: EntityManager, removed entity: Entity) {
        notify(removed: entity)
    }
}

class ComponentMock: GKComponent {
    
    var updateExpectation = XCTestExpectation(description: "Component was updated")
    
    override func update(deltaTime seconds: TimeInterval) {
        updateExpectation.fulfill()
    }
}
