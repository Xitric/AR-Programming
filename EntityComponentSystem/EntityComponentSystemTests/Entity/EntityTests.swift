//
//  EntityTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import GameplayKit
@testable import EntityComponentSystem

class EntityTests: XCTestCase {

    private var entity: Entity!
    // swiftlint:disable weak_delegate
    private var entityDelegate: EntityDelegateImpl!
    // swiftlint:enable weak_delegate
    private var superComponent: GKComponent!
    private var subComponent: GKComponent!

    override func setUp() {
        entity = Entity()
        entityDelegate = EntityDelegateImpl()
        entity.delegate = entityDelegate
        superComponent = SuperComponent()
        subComponent = SubComponent()
    }

    // MARK: addComponent
    func testAddComponent_NoDelegate() {
        //Act
        entity.delegate = nil
        entity.addComponent(superComponent)

        //Assert
        XCTAssertTrue(entity.components.contains(superComponent))
    }

    func testAddComponent_FirstComponent() {
        //Arrange
        entityDelegate.expect(superComponent)

        //Act
        entity.addComponent(superComponent)

        //Assert
        wait(for: [entityDelegate.addExpectation], timeout: 1)
        XCTAssertEqual(entity.components.count, 1)
        XCTAssertTrue(entity.components.contains(superComponent))
    }

    func testAddComponent_SecondComponent() {
        //Arrange
        entity.addComponent(superComponent)
        entityDelegate.expect(subComponent)

        //Act
        entity.addComponent(subComponent)

        //Assert
        wait(for: [entityDelegate.addExpectation], timeout: 1)
        XCTAssertEqual(entity.components.count, 2)
        XCTAssertTrue(entity.components.contains(subComponent))
    }

    // MARK: removeComponent
    func testRemoveComponent_LastComponent() {
        //Arrange
        entity.addComponent(superComponent)
        entityDelegate.expect(superComponent)

        //Act
        entity.removeComponent(ofType: SuperComponent.self)

        //Assert
        wait(for: [entityDelegate.removeExpectation], timeout: 1)
        XCTAssertEqual(entity.components.count, 0)
    }

    func testRemoveComponent_Supertype() {
        //Arrange
        entity.addComponent(superComponent)
        entity.addComponent(subComponent)
        entityDelegate.expect(superComponent)

        //Act
        entity.removeComponent(ofType: SuperComponent.self)

        //Assert
        wait(for: [entityDelegate.removeExpectation], timeout: 1)
        XCTAssertEqual(entity.components.count, 1)
        XCTAssertTrue(entity.components.contains(subComponent))
    }

    func testRemoveComponent_Subtype() {
        //Arrange
        entity.addComponent(superComponent)
        entity.addComponent(subComponent)
        entityDelegate.expect(subComponent)

        //Act
        entity.removeComponent(ofType: SubComponent.self)

        //Assert
        wait(for: [entityDelegate.removeExpectation], timeout: 1)
        XCTAssertEqual(entity.components.count, 1)
        XCTAssertTrue(entity.components.contains(superComponent))
    }
}

class SuperComponent: GKComponent {}
class SubComponent: SuperComponent {}

class EntityDelegateImpl: AddRemoveDelegateMock<GKComponent>, EntityDelegate {
    func entity(_ entity: Entity, addedComponent component: GKComponent) {
        notify(added: component)
    }

    func entity(_ entity: Entity, removedComponent component: GKComponent) {
        notify(removed: component)
    }
}
