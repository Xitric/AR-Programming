//
//  RotationActionTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 29/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class RotationActionTests: XCTestCase {

    private var action: RotationAction!
    
    override func setUp() {
        action = RotationAction(direction: .left)
    }
    
    //Mark: getActionComponent
    func testGetActionComponent() {
        //Arrange
        action.strength = 1
        
        //Act
        let result = action.getActionComponent()
        
        //Assert
        XCTAssertTrue(result is RotationActionComponent)
        let rotation = (result as! RotationActionComponent).rotation
        XCTAssertTrue(quatEqual(rotation, simd_quatd(angle: Double.pi / 2, axis: simd_double3(0, 1, 0)), tolerance: 0.000001))
    }
    
    func testGetActionComponent_DoubleStrength() {
        //Arrange
        action.strength = 2
        
        //Act
        let result = action.getActionComponent()
        
        //Assert
        XCTAssertTrue(result is RotationActionComponent)
        let rotation = (result as! RotationActionComponent).rotation
        XCTAssertTrue(quatEqual(rotation, simd_quatd(angle: Double.pi, axis: simd_double3(0, 1, 0)), tolerance: 0.000001))
    }
    
    func testGetActionComponent_TripleStrength() {
        //Arrange
        action.strength = 3
        
        //Act
        let result = action.getActionComponent()
        
        //Assert
        XCTAssertTrue(result is CompoundActionComponent)
        let firstRotation = ((result as! CompoundActionComponent).firstAction as! RotationActionComponent).rotation
        let secondRotation = ((result as! CompoundActionComponent).secondAction as! RotationActionComponent).rotation
        
        XCTAssertTrue(quatEqual(firstRotation, simd_quatd(angle: Double.pi, axis: simd_double3(0, 1, 0)), tolerance: 0.000001))
        XCTAssertTrue(quatEqual(secondRotation, simd_quatd(angle: Double.pi / 2, axis: simd_double3(0, 1, 0)), tolerance: 0.000001))
    }
}
