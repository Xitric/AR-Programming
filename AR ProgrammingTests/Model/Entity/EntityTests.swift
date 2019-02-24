//
//  EntityTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import GameplayKit
@testable import AR_Programming

class EntityTests: XCTestCase {

    private var entity: Entity!
    private var entityDelegate: EntityDelegateImpl!
    private var superComponent: GKComponent!
    private var subComponent: GKComponent!
    
    override func setUp() {
        entity = Entity()
        entityDelegate = EntityDelegateImpl()
        superComponent = SuperComponent()
        subComponent = SubComponent()
    }

    //MARK: addComponent
    func testAddComponent_NoDelegate() {
        //Act
        entity.addComponent(superComponent)
        
        //Assert
        XCTAssertTrue(entity.components.contains(superComponent))
    }
    
    func testAddComponent_FirstComponent() {
        //Arrange
        entity.delegate = entityDelegate
        entityDelegate.expect(component: superComponent)
        
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
        entity.delegate = entityDelegate
        entityDelegate.expect(component: subComponent)
        
        //Act
        entity.addComponent(subComponent)
        
        //Assert
        wait(for: [entityDelegate.addExpectation], timeout: 1)
        XCTAssertEqual(entity.components.count, 2)
        XCTAssertTrue(entity.components.contains(subComponent))
    }
    
    //MARK: removeComponent
    func testRemoveComponent_LastComponent() {
        //Arrange
        entity.addComponent(superComponent)
        entity.delegate = entityDelegate
        entityDelegate.expect(component: superComponent)
        
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
        entity.delegate = entityDelegate
        entityDelegate.expect(component: superComponent)
        
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
        entity.delegate = entityDelegate
        entityDelegate.expect(component: subComponent)
        
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

class EntityDelegateImpl: EntityDelegate {
    
    let addExpectation = XCTestExpectation(description: "Component added")
    let removeExpectation = XCTestExpectation(description: "Component removed")
    
    private var expectedComponent: GKComponent?
    
    func expect(component: GKComponent) {
        expectedComponent = component
    }
    
    func entity(_ entity: Entity, addedComponent component: GKComponent) {
        if let expectedComponent = expectedComponent {
            if expectedComponent == component {
                addExpectation.fulfill()
            }
        }
    }
    
    func entity(_ entity: Entity, removedComponent component: GKComponent) {
        if let expectedComponent = expectedComponent {
            if expectedComponent == component {
                removeExpectation.fulfill()
            }
        }
    }
}
