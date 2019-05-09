//
//  MovementActionComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class MovementActionComponentTests: XCTestCase {

    private var entity: Entity!
    private var transform: TransformComponent!
    private var moveComponent: MovementActionComponent!
    private var manager: EntityManager!

    override func setUp() {
        entity = Entity()
        transform = TransformComponent()
        moveComponent = MovementActionComponent(movement: simd_double3(1, -2, 0), duration: 2)

        entity.addComponent(transform)
        entity.addComponent(moveComponent)

        manager = EntityManager()
        manager.addEntity(entity)
    }

    // MARK: update
    func testUpdate_MovementNoRotation() {
        //Act
        manager.update(delta: 3)

        //Assert
        XCTAssertTrue(vectEqual(transform.location, simd_double3(1, -2, 0), tolerance: 0.000001))
    }

    func testUpdate_MovementWithRotation() {
        //Arrange
        transform.rotation = simd_quatd(angle: 0.25 * Double.pi, axis: simd_double3(0, 1, 0))

        //Act
        manager.update(delta: 3)

        //Assert
        XCTAssertTrue(vectEqual(transform.location, simd_double3(0.707, -2, -0.707), tolerance: 0.001))
    }

    func testUpdate_CompletionHandler() {
        //Arrange
        let completionHandlerExpectation = expectation(description: "Completion handler called")
        moveComponent.onComplete = {
            completionHandlerExpectation.fulfill()
        }

        //Act
        manager.update(delta: 3)

        //Assert
        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(entity.components.contains(moveComponent))
    }
}
