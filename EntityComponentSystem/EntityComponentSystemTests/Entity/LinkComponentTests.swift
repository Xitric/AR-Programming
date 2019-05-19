//
//  LinkComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import EntityComponentSystem

class LinkComponentTests: XCTestCase {

    private var entityManager: EntityManager!
    private var owner: Entity!
    private var ownerTransform: TransformComponent!
    private var collectible: Entity!
    private var collectibleTransform: TransformComponent!

    override func setUp() {
        entityManager = EntityManager()

        owner = entityManager.player
        ownerTransform = owner.component(subclassOf: TransformComponent.self)!

        collectible = Entity()
        collectibleTransform = TransformComponent()
        collectible.addComponent(collectibleTransform)
    }

    func testRotation_SameAxis() {
        //Arrange
        owner.addComponent(LinkComponent(otherEntity: collectible))

        let rotation = simd_quatd(angle: Double.pi / 2, axis: simd_double3(0, 1, 0))
        ownerTransform.rotation = rotation

        //Act
        entityManager.update(delta: 1)

        //Assert
        XCTAssertTrue(quatEqual(collectibleTransform.rotation, rotation, tolerance: 0.000001))
        XCTAssertTrue(vectEqual(collectibleTransform.location, simd_double3(0, 0, 0), tolerance: 0.000001))
    }

    func testRotation_OffsetAxis() {
        //Arrange
        collectibleTransform.location = simd_double3(1, 0, 0)
        owner.addComponent(LinkComponent(otherEntity: collectible))

        let rotation = simd_quatd(angle: Double.pi / 2, axis: simd_double3(0, 1, 0))
        ownerTransform.rotation = rotation

        //Act
        entityManager.update(delta: 1)

        //Assert
        XCTAssertTrue(quatEqual(collectibleTransform.rotation, rotation, tolerance: 0.000001))
        XCTAssertTrue(vectEqual(collectibleTransform.location, simd_double3(0, 0, -1), tolerance: 0.000001))
    }
}
