//
//  LeftCardTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import AR_Programming

class LeftCardTests: XCTestCase {

    private var entity: Entity!
    private var card: LeftCard!
    
    override func setUp() {
        entity = Entity()
        entity.addComponent(TransformComponent())
        
        card = LeftCard()
    }

    //MARK: getAction
    func testGetAction_NoBaseRotation() {
        //Act
        let action = card.getAction(forEntity: entity) as! RotationActionComponent
        
        //Assert
        XCTAssertTrue(quatEqual(action.startRotation,
                            simd_quatd(ix: 0, iy: 0, iz: 0, r: 1),
                            tolerance: 0.000001))
        XCTAssertTrue(quatEqual(action.goalRotation,
                            simd_quatd(angle: 0.5 * Double.pi, axis: simd_double3(0, 1, 0)),
                            tolerance: 0.000001))
    }
    
    func testGetAction_WithExistingRotation() {
        //Arrange
        let transform = entity.component(ofType: TransformComponent.self)!
        
        //Rotated 45 degrees on x, then 45 degrees on local z axis
        transform.rotation = simd_quatd(angle: 0.25 * Double.pi, axis: simd_double3(1, 0, 0))
            * simd_quatd(angle: 0.25 * Double.pi, axis: simd_double3(0, 0, 1))
        
        //Act
        let action = card.getAction(forEntity: entity) as! RotationActionComponent
        
        //Assert
        XCTAssertTrue(quatEqual(action.startRotation,
                            simd_quatd(ix: 0.354, iy: -0.146, iz: 0.354, r: 0.854),
                            tolerance: 0.001))
        //Ensure that the entity is rotated an additional 90 degrees around its local y axis
        XCTAssertTrue(quatEqual(action.goalRotation,
                            simd_quatd(ix: 0, iy: 0.5, iz: 0.5, r: 0.707),
                            tolerance: 0.001))
    }
}
