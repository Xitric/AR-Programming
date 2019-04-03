//
//  RotationActionComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import AR_Programming

class RotationActionComponentTests: XCTestCase {

    private var entity: Entity!
    private var transform: TransformComponent!
    
    override func setUp() {
        entity = Entity()
        transform = TransformComponent()
        
        entity.addComponent(transform)
    }
    
    //MARK: update
    func testUpdate_Rotation() {
        //Arrange
        let goal = simd_quatd(angle: Double.pi, axis: simd_double3(0, 1, 0))
        let rotationComponent = RotationActionComponent(by: goal,
                                                        duration: 1)
        entity.addComponent(rotationComponent)
        
        //Act
        entity.update(deltaTime: 2)
        
        //Assert
        XCTAssertTrue(quatEqual(transform.rotation, goal, tolerance: 0.000001))
    }
    
    func testUpdate_WithExistingRotation() {
        //Arrange
        transform.rotation = simd_quatd(ix: 0.354, iy: 0.354, iz: -0.146, r: 0.854)
        
        let rotationComponent = RotationActionComponent(by: simd_quatd(angle: 0.25 * Double.pi, axis: simd_double3(0, 1, 0)),
                                                        duration: 1)
        entity.addComponent(rotationComponent)
        
        //Act
        entity.update(deltaTime: 2)
        
        //Assert
        XCTAssertTrue(quatEqual(transform.rotation,
                            simd_quatd(ix: 0.383, iy: 0.653, iz: 0, r: 0.653),
                            tolerance: 0.001))
    }
    
    func testUpdate_CompletionHandler() {
        //Arrange
        let rotationComponent = RotationActionComponent(by: simd_quatd(angle: Double.pi, axis: simd_double3(0, 1, 0)),
                                                        duration: 2)
        entity.addComponent(rotationComponent)
        
        let completionHandlerExpectation = expectation(description: "Completion handler called")
        rotationComponent.onComplete = {
            completionHandlerExpectation.fulfill()
        }
        
        //Act
        entity.update(deltaTime: 3)
        
        //Assert
        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(entity.components.contains(rotationComponent))
    }
}
