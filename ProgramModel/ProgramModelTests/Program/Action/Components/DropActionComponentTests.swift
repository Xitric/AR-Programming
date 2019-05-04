//
//  DropActionComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class DropActionComponentTests: XCTestCase {

    private var entityManager: EntityManager!
    private var owner: Entity!
    private var collectible: Entity!
    private var dropActionComponent: DropActionComponent!
    private var completionHandlerExpectation: XCTestExpectation!

    override func setUp() {
        entityManager = EntityManager()

        owner = entityManager.player

        collectible = Entity()
        collectible.addComponent(TransformComponent())
        collectible.addComponent(CollisionComponent(size: simd_double3(0.1, 0.1, 0.1)))
        collectible.addComponent(CollectibleComponent())
        entityManager.addEntity(collectible)

        dropActionComponent = DropActionComponent()
        completionHandlerExpectation = expectation(description: "Completion handler called")
        dropActionComponent.onComplete = { [weak self] in
            self?.completionHandlerExpectation.fulfill()
        }
    }

    func testDropEntity() {
        //Arrange
        owner.addComponent(PickupActionComponent())
        entityManager.update(delta: 2)
        let linkBefore = owner.component(ofType: LinkComponent.self)
        XCTAssertNotNil(linkBefore)
        XCTAssertEqual(linkBefore?.otherEntity, collectible)

        owner.addComponent(dropActionComponent)

        //Act
        entityManager.update(delta: 2)
        entityManager.update(delta: 2)

        //Assert
        let linkAfter = owner.component(ofType: LinkComponent.self)
        XCTAssertNil(linkAfter)

        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(owner.components.contains(dropActionComponent))
    }

    func testDropEntity_HoldingNothing() {
        //Arrange
        owner.addComponent(dropActionComponent)

        //Act
        entityManager.update(delta: 2)

        //Assert
        let link = owner.component(ofType: LinkComponent.self)
        XCTAssertNil(link)

        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(owner.components.contains(dropActionComponent))
    }
}
