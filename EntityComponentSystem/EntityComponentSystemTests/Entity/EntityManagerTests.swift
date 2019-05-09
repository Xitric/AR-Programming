//
//  EntityManagerTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import GameplayKit
@testable import EntityComponentSystem

class EntityManagerTests: XCTestCase {

    private var entityManager: EntityManager!
    // swiftlint:disable weak_delegate
    private var entityManagerDelegate: EntityManagerDelegateImpl!
    // swiftlint:enable weak_delegate

    override func setUp() {
        entityManager = EntityManager()
        entityManagerDelegate = EntityManagerDelegateImpl()
        entityManager.delegate = entityManagerDelegate
    }

    // MARK: addEntity
    func testAddEntity() {
        //Arrange
        let component1 = ComponentMock()
        let entity1 = Entity()
        entity1.addComponent(component1)
        entityManagerDelegate.expect(entity1)

        //Act
        entityManager.addEntity(entity1)

        //Assert
        wait(for: [entityManagerDelegate.addExpectation], timeout: 0.1)

        //Second entity
        //Arrange
        let component2 = ComponentMock()
        let entity2 = Entity()
        entity2.addComponent(component2)
        entityManagerDelegate.expect(entity2)

        //Act
        entityManager.addEntity(entity2)

        //Assert
        wait(for: [entityManagerDelegate.addExpectation], timeout: 0.1)
        entityManager.update(delta: 1)
        wait(for: [component1.updateExpectation], timeout: 0.1)
        wait(for: [component2.updateExpectation], timeout: 0.1)
    }

    func testAddEntity_WithComponentWithEntityManager() {
        //Arrange
        let component = Component()
        let entity = Entity()
        entity.addComponent(component)

        //Act
        entityManager.addEntity(entity)

        //Assert
        XCTAssertTrue(component.entityManager != nil)
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
        wait(for: [component.updateExpectation], timeout: 0.1)
    }

    func testManagerNotifiedOnEntityChanges() {
        //Arrange
        let entity = Entity()
        entityManager.addEntity(entity)

        //Act
        let component = ComponentMock()
        entity.addComponent(component)

        //Assert
        entityManager.update(delta: 1)
        wait(for: [component.updateExpectation], timeout: 0.1)
    }

    // MARK: removeEntity
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
        wait(for: [entityManagerDelegate.removeExpectation], timeout: 0.1)
        entityManager.update(delta: 1)
        wait(for: [component.updateExpectation], timeout: 0.1)
    }

    func testRemoveEntity_WithComponentWithEntityManager() {
        //Arrange
        let component = Component()
        let entity = Entity()
        entity.addComponent(component)

        //Act
        entityManager.addEntity(entity)
        entityManager.removeEntity(entity)

        //Assert
        XCTAssertTrue(component.entityManager == nil)
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
        entityManager.update(delta: 1)
        wait(for: [component.updateExpectation], timeout: 0.1)
    }

    // MARK: addSystem
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

        let system = GKComponentSystem.init(componentClass: ComponentMock.self)

        //Act
        entityManager.addSystem(system)

        //Assert
        XCTAssertTrue(system.components.contains(component1))
        XCTAssertTrue(system.components.contains(component2))
    }

    // MARK: removeSystem
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
        entityManager.update(delta: 1)
        wait(for: [component1.updateExpectation], timeout: 0.1)
        wait(for: [component2.updateExpectation], timeout: 0.1)
        XCTAssertTrue(system.components.isEmpty)
    }

    // MARK: getEntities
    // swiftlint:disable function_body_length
    func testGetEntities() {
        //Arrange
        var entitiesWithComponentType1 = [Entity]()
        var entitiesWithComponentType2 = [Entity]()
        var entitiesWithComponentType3 = [Entity]()
        var entitiesWithComponentType4 = [Entity]()
        var entitiesWithComponentType1And2 = [Entity]()
        var entitiesWithComponentType1And2And3 = [Entity]()
        var entitiesWithComponentType3And4 = [Entity]()

        let entity1 = Entity()
        let entity2 = Entity()
        let entity3 = Entity()
        let entity4 = Entity()
        let entity5 = Entity()
        let entity6 = Entity()

        let component1 = ComponentType1()
        let component2 = ComponentType2()
        let component3 = ComponentType3()

        entity1.addComponent(component1)
        entity2.addComponent(component1)
        entity3.addComponent(component1)
        entity4.addComponent(component1)
        entity5.addComponent(component1)

        entity1.addComponent(component2)
        entity2.addComponent(component2)
        entity3.addComponent(component2)

        entity1.addComponent(component3)
        entity1.addComponent(component3)
        entity1.addComponent(component3)

        entityManager.addEntity(entity1)
        entityManager.addEntity(entity2)
        entityManager.addEntity(entity3)
        entityManager.addEntity(entity4)
        entityManager.addEntity(entity5)
        entityManager.addEntity(entity6)

        //Act
        entitiesWithComponentType1 = entityManager.getEntities(withComponents: ComponentType1.self)
        entitiesWithComponentType2 = entityManager.getEntities(withComponents: ComponentType2.self)
        entitiesWithComponentType3 = entityManager.getEntities(withComponents: ComponentType3.self)
        entitiesWithComponentType4 = entityManager.getEntities(withComponents: ComponentType4.self)
        entitiesWithComponentType1And2 = entityManager.getEntities(withComponents: ComponentType2.self)
        entitiesWithComponentType1And2And3 = entityManager.getEntities(withComponents: ComponentType1.self, ComponentType2.self, ComponentType3.self)
        entitiesWithComponentType3And4 = entityManager.getEntities(withComponents: ComponentType3.self, ComponentType4.self)

        //Assert
        XCTAssertTrue(entitiesWithComponentType1.count == 5)
        XCTAssertTrue(entitiesWithComponentType2.count == 3)
        XCTAssertTrue(entitiesWithComponentType3.count == 1)
        XCTAssertTrue(entitiesWithComponentType4.count == 0)
        XCTAssertTrue(entitiesWithComponentType1And2.count == 3)
        XCTAssertTrue(entitiesWithComponentType1And2And3.count == 1)
        XCTAssertTrue(entitiesWithComponentType3And4.count == 0)
    }
    // swiftlint:enable function_body_length

    // MARK: addedComponent
    func testAddedComponentWithEntityManager() {
        //Arrange
        let entity = Entity()
        let component = Component()

        //Act
        entityManager.entity(entity, addedComponent: component)

        //Assert
        XCTAssertTrue(component.entityManager != nil)

    }

    // MARK: removedComponent
    func testRemovedComponentWithEntityManager() {
        //Arrange
        let entity = Entity()
        let component = Component()

        //Act
        entityManager.entity(entity, addedComponent: component)
        entityManager.entity(entity, removedComponent: component)

        //Assert
        XCTAssertTrue(component.entityManager == nil)
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

class ComponentType1: GKComponent {}
class ComponentType2: GKComponent {}
class ComponentType3: Component {}
class ComponentType4: Component {}
