//
//  CardTests.swift
//  VisionCardTestTests
//
//  Created by user143563 on 2/3/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import XCTest
import SceneKit
@testable import AR_Programming

class CardTests: XCTestCase {

    private var card: Card!
    private var node: SCNNode!
    
    override func setUp() {
        card = StartCard()
        let parent = SCNNode()
        node = SCNNode()
        parent.addChildNode(node)
    }
    
    func testConvertAxis1() {
        //Arrange
        let yAxisRotation = GLKQuaternionMakeWithAngleAndAxis(Float.pi / 2, 0, 1, 0)
        
        //Act
        node.localRotate(by: SCNQuaternion(x: yAxisRotation.x, y: yAxisRotation.y, z: yAxisRotation.z, w: yAxisRotation.w))
        
        //Assert
        let result = card.convert(axis: SCNVector3(1, 0, 0), to: node)
        XCTAssertEqual(result.x, 0, accuracy: 0.00001)
        XCTAssertEqual(result.y, 0, accuracy: 0.00001)
        XCTAssertEqual(result.z, -1, accuracy: 0.00001)
    }
    
    func testConvertAxis2() {
        //Arrange
        let yAxisRotation = GLKQuaternionMakeWithAngleAndAxis(Float.pi / 2, 0, 1, 0)
        let xAxisRotation = GLKQuaternionMakeWithAngleAndAxis(Float.pi * 3 / 2, 1, 0, 0)
        //First rotate around y, then around x
        let rotation = GLKQuaternionMultiply(xAxisRotation, yAxisRotation)
        
        //Act
        node.localRotate(by: SCNQuaternion(x: rotation.x, y: rotation.y, z: rotation.z, w: rotation.w))
        
        //Assert
        let result = card.convert(axis: SCNVector3(1, 0, 0), to: node)
        XCTAssertEqual(result.x, 0, accuracy: 0.00001)
        XCTAssertEqual(result.y, -1, accuracy: 0.00001)
        XCTAssertEqual(result.z, 0, accuracy: 0.00001)
    }
}
