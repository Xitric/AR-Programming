//
//  EntityModelLoaderTests.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 07/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ARProgramming

class EntityModelLoaderTests: XCTestCase {

    private var entityManager: EntityManager!
    private var rootNode: SCNNode!
    private var entityModelLoader: EntityModelLoader!

    override func setUp() {
        entityManager = EntityManager()
        rootNode = SCNNode()
        entityModelLoader = EntityModelLoader(entityManager: entityManager, wardrobe: WardrobeMock(), root: rootNode)
    }

    func testAddedEntity() {
        // Arrange
        let transform = TransformComponent(location: simd_double3(x: 0, y: 0, z: 0))
        let resource = ResourceComponent(resourceIdentifier: "")
        let entity1 = Entity()
        let entity2 = Entity()
        entity1.addComponent(transform)
        entity1.addComponent(resource)

        // Assume
        XCTAssertNil(entity1.component(ofType: SCNNodeComponent.self))
        XCTAssertNil(entity2.component(ofType: SCNNodeComponent.self))
        XCTAssertEqual(rootNode.childNodes.count, 1) // Player

        // Act
        entityModelLoader.entityManager(entityManager, added: entity1)

        // Assert
        XCTAssertNotNil(entity1.component(ofType: SCNNodeComponent.self))
        XCTAssertEqual(rootNode.childNodes.count, 2)

        // Act
        entityModelLoader.entityManager(entityManager, added: entity2)

        // Assert
        XCTAssertNil(entity2.component(ofType: SCNNodeComponent.self))
        XCTAssertEqual(rootNode.childNodes.count, 2)
    }

    func testRemovedEntity() {
        // Arrange
        let sceneNode = SCNNodeComponent(node: SCNNode())
        let entity1 = Entity()
        let entity2 = Entity()
        entity1.addComponent(sceneNode)

        // Assume
        XCTAssertNotNil(entity1.component(ofType: SCNNodeComponent.self))
        XCTAssertNil(entity1.component(ofType: TransformComponent.self))
        XCTAssertNil(entity2.component(ofType: SCNNodeComponent.self))
        XCTAssertNil(entity2.component(ofType: TransformComponent.self))

        // Act
        entityModelLoader.entityManager(entityManager, removed: entity1)

        // Assert
        XCTAssertNil(entity1.component(ofType: SCNNodeComponent.self))
        XCTAssertNotNil(entity1.component(ofType: TransformComponent.self))

        // Act
        entityModelLoader.entityManager(entityManager, removed: entity2)

        // Assert
        XCTAssertNil(entity2.component(ofType: SCNNodeComponent.self))
        XCTAssertNil(entity2.component(ofType: TransformComponent.self))
    }
}

private class WardrobeMock: WardrobeRepository {

    func getFileNames() -> [String] {
        return [""]
    }

    func selectedRobotSkin(completion: @escaping (String?, Error?) -> Void) {
        completion(nil, nil)
    }

    func setRobotSkin(named choice: String, completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

}
