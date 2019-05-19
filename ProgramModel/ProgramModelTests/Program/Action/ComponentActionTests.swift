//
//  ComponentActionTests.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 11/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class ComponentActionTests: XCTestCase {

    private var entityManager: EntityManager!
    private var entity: Entity!
    private var callbackExpectation: XCTestExpectation!

    override func setUp() {
        entityManager = EntityManager()
        entity = Entity()
        entityManager.addEntity(entity)
        callbackExpectation = expectation(description: "Callback called")
    }

    // MARK: run
    func testRun_WithComponent() {
        //Arrange
        let action = ComponentActionStub()

        //Act
        action.run(onEntity: entity, withProgramDelegate: nil) { [weak self] in
            self?.callbackExpectation.fulfill()
        }
        entityManager.update(delta: 1)

        //Assert
        wait(for: [callbackExpectation], timeout: 0.1)
    }

    func testRun_WithComponentNoUpdate() {
        //Arrange
        let action = ComponentActionStub()
        callbackExpectation.isInverted = true

        //Act
        action.run(onEntity: entity, withProgramDelegate: nil) { [weak self] in
            self?.callbackExpectation.fulfill()
        }

        //Assert
        wait(for: [callbackExpectation], timeout: 0.1)
    }

    func testRun_NoComponent() {
        //Arrange
        let action = ComponentAction()

        //Act
        action.run(onEntity: entity, withProgramDelegate: nil) { [weak self] in
            self?.callbackExpectation.fulfill()
        }

        //Assert
        wait(for: [callbackExpectation], timeout: 0.1)
    }
}

private class ComponentActionStub: ComponentAction {

    override func getActionComponent() -> ActionComponent? {
        return ActionComponentStub()
    }
}

private class ActionComponentStub: ActionComponent {

    override func update(deltaTime seconds: TimeInterval) {
        complete()
    }
}
