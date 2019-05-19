//
//  CollisionComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 21/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import EntityComponentSystem

class CollisionComponentTests: XCTestCase {

    private var smallEntity: Entity! //This is entirely contained within bigEntity
    private var smallEntity2: Entity! //This is entirely contained within bigEntity, and touches one face of smallEntity
    private var bigEntity: Entity! //This entirely contains smallEntity
    private var mediumEntity: Entity! //This overlaps only somewhat with bigEntity but not with smallEntity

    override func setUp() {
        smallEntity = Entity()
        let smallCollision = CollisionComponent(size: simd_double3(2, 2, 2))
        let smallTransform = TransformComponent(location: simd_double3(3, 2, -7))
        smallEntity.addComponent(smallCollision)
        smallEntity.addComponent(smallTransform)

        smallEntity2 = Entity()
        let smallCollision2 = CollisionComponent(size: simd_double3(2, 2, 2), offset: simd_double3(4, -1, 1))
        let smallTransform2 = TransformComponent(location: simd_double3(0, 1, -8))
        smallEntity2.addComponent(smallCollision2)
        smallEntity2.addComponent(smallTransform2)

        bigEntity = Entity()
        let bigCollision = CollisionComponent(size: simd_double3(6, 8, 16))
        let bigTransform = TransformComponent()
        bigTransform.location = simd_double3(4, 0, -4.5)
        bigEntity.addComponent(bigCollision)
        bigEntity.addComponent(bigTransform)

        mediumEntity = Entity()
        let mediumCollision = CollisionComponent(size: simd_double3(4, 8, 3), offset: simd_double3(5, 0, 0))
        let mediumTransform = TransformComponent(location: simd_double3(-4, -2, -3))
        mediumEntity.addComponent(mediumCollision)
        mediumEntity.addComponent(mediumTransform)
    }

    func testCollidesWith() {
        //Act & Assert
        XCTAssertTrue(collides(smallEntity, smallEntity2))
        XCTAssertTrue(collides(smallEntity, bigEntity))
        XCTAssertFalse(collides(smallEntity, mediumEntity))

        XCTAssertTrue(collides(smallEntity2, bigEntity))
        XCTAssertFalse(collides(smallEntity2, mediumEntity))

        XCTAssertTrue(collides(bigEntity, mediumEntity))
    }

    private func collides(_ a: Entity, _ b: Entity) -> Bool {
        guard let collisionA = a.component(ofType: CollisionComponent.self),
            let collisionB = b.component(ofType: CollisionComponent.self)
            else { return false }

        return collisionA.collidesWith(other: collisionB) &&
            collisionB.collidesWith(other: collisionA)
    }
}
