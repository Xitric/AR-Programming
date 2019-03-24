//
//  PickupActionComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import AR_Programming

class PickupActionComponentTests: XCTestCase {

    private var entityManager: EntityManager!
    private var owner: Entity!
    private var ownerTransform: TransformComponent!
    private var collectible: Entity!
    private var pickupActionComponent: PickupActionComponent!
    private var completionHandlerExpectation: XCTestExpectation!
    
    override func setUp() {
        entityManager = EntityManager()
        
        owner = entityManager.player
        ownerTransform = owner.component(subclassOf: TransformComponent.self)
        
        collectible = createCollectible()
        
        pickupActionComponent = PickupActionComponent()
        completionHandlerExpectation = expectation(description: "Completion handler called")
        pickupActionComponent.onComplete = { [weak self] in
            self?.completionHandlerExpectation.fulfill()
        }
    }
    
    private func createCollectible() -> Entity {
        let c = Entity()
        c.addComponent(TransformComponent())
        c.addComponent(CollisionComponent(size: simd_double3(0.1, 0.1, 0.1)))
        c.addComponent(CollectibleComponent())
        entityManager.addEntity(c)
        
        return c
    }

    func testPickupEntity() {
        //Arrange
        owner.addComponent(pickupActionComponent)
        
        //Act
        entityManager.update(delta: 2)
        
        //Assert
        let link = owner.component(ofType: LinkComponent.self)
        XCTAssertNotNil(link)
        XCTAssertEqual(link?.otherEntity, collectible)
        
        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(owner.components.contains(pickupActionComponent))
    }
    
    func testPickupEntity_NoCollectible() {
        //Arrange
        ownerTransform.location += simd_double3(2, 0, 0)
        owner.addComponent(pickupActionComponent)
        
        //Act
        entityManager.update(delta: 2)
        
        //Assert
        let link = owner.component(ofType: LinkComponent.self)
        XCTAssertNil(link)
        
        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(owner.components.contains(pickupActionComponent))
    }
    
    func testPickupEntity_AlreadyHolding() {
        //Arrange
        owner.addComponent(pickupActionComponent)
        entityManager.update(delta: 2)
        
        let movement = simd_double3(2, 0, 0)
        let collectible2 = createCollectible()
        collectible2.component(subclassOf: TransformComponent.self)!.location += movement
        ownerTransform.location += movement
        
        let pickupActionComponent2 = PickupActionComponent()
        let completionHandlerExpectation2 = expectation(description: "Completion handler called")
        pickupActionComponent2.onComplete = {
            completionHandlerExpectation2.fulfill()
        }
        owner.addComponent(pickupActionComponent2)
        
        //Act
        entityManager.update(delta: 2)
        
        //Assert
        let link = owner.component(ofType: LinkComponent.self)
        XCTAssertNotNil(link)
        XCTAssertEqual(link?.otherEntity, collectible)
        
        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(owner.components.contains(pickupActionComponent))
        wait(for: [completionHandlerExpectation2], timeout: 1)
        XCTAssertFalse(owner.components.contains(pickupActionComponent2))
    }
}
