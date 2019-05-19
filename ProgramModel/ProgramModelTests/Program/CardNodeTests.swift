//
//  SuccessorCardNodeTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/3/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class CardNodeTests: XCTestCase {

    var node: CardNode!

    override func setUp() {
        node = CardNode(card: BasicCard(internalName: "testCard", type: .control, supportsParameter: true, requiresParameter: false, connectionAngles: [0]))
    }

    // MARK: addSuccessor
    func testAddSuccessor() {
        //Act
        node.addSuccessor(CardNode(card: BasicCard(internalName: "testSuccessor", type: .action, supportsParameter: false, requiresParameter: false, connectionAngles: [0])))

        //Assert
        XCTAssertEqual(node.successors.count, 1)
        XCTAssertEqual(node.children.count, 1)
        XCTAssertEqual(node.successors[0]?.card.internalName, "testSuccessor")

        //Act
        node.addSuccessor(nil)

        //Assert
        XCTAssertEqual(node.successors.count, 2)
        XCTAssertEqual(node.children.count, 1)
        XCTAssertEqual(node.successors[0]?.card.internalName, "testSuccessor")
        XCTAssertEqual(node.children[0].card.internalName, "testSuccessor")
        XCTAssertNil(node.successors[1])
    }

    // MARK: setParameter
    func testSetParameter() {
        //Act
        node.setParameter(CardNode(card: ParameterCard(parameter: 2)))

        //Assert
        XCTAssertEqual(node.successors.count, 0)
        XCTAssertEqual(node.children.count, 1)
        XCTAssertEqual(node.children[0].card.internalName, "param2")
        XCTAssertEqual(node.parameter, 2)
    }

    func testSetParameter_InvalidCard() {
        //Act
        node.setParameter(CardNode(card: BasicCard(internalName: "testSuccessor", type: .action, supportsParameter: false, requiresParameter: false, connectionAngles: [0])))

        //Assert
        XCTAssertEqual(node.successors.count, 0)
        XCTAssertEqual(node.children.count, 0)
        XCTAssertNil(node.parameter)
    }
}
