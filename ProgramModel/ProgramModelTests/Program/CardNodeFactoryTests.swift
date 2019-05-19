//
//  CardNodeFactoryTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/3/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class CardNodeFactoryTests: XCTestCase {

    private var factory: CardNodeFactory!

    override func setUp() {
        factory = CardNodeFactory()
    }

    // MARK: cardNodeWithCode
    func testCardNodeWithCode_ValidCode() {
        //Act
        let result = try? factory.cardNode(withCode: "3")

        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.card.internalName, "right")
    }

    func testCardNodeWithCode_UnknownCode() {
        //Act & Assert
        XCTAssertThrowsError(try factory.cardNode(withCode: "-1")) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.unknownCode(code: "-1"))
        }
    }

    // MARK: register
    func testRegister_NewNode() {
        //Act
        factory.register(cardNode: CardNode(
            card: BasicCard(internalName: "left",
                            type: .action,
                            supportsParameter: true,
                            requiresParameter: false,
                            connectionAngles: [0])), withCode: "200")
        factory.register(cardNode: CardNode(
            card: BasicCard(internalName: "jump",
                            type: .action,
                            supportsParameter: true,
                            requiresParameter: false,
                            connectionAngles: [0])), withCode: "-6")

        //Assert
        let leftCard = try? factory.cardNode(withCode: "200")
        XCTAssertNotNil(leftCard)
        XCTAssertEqual(leftCard?.card.internalName, "left")

        let jumpCard = try? factory.cardNode(withCode: "-6")
        XCTAssertNotNil(jumpCard)
        XCTAssertEqual(jumpCard?.card.internalName, "jump")
    }

    func testRegister_ExistingNode() {
        //Act
        let cardNode = CardNode(
            card: BasicCard(internalName: "left",
                            type: .action,
                            supportsParameter: true,
                            requiresParameter: false,
                            connectionAngles: [0]))
        factory.register(cardNode: cardNode, withCode: "3")

        //Assert
        let result = try? factory.cardNode(withCode: "3")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.card.internalName, cardNode.card.internalName)
    }

    // MARK: cardCode
    func testCardCode() {
        XCTAssertEqual(factory.cardCode(fromInternalName: "move"), "1")
        XCTAssertEqual(factory.cardCode(fromInternalName: "block"), "7")
        XCTAssertEqual(factory.cardCode(fromInternalName: "param2"), "9")
        XCTAssertEqual(factory.cardCode(fromInternalName: "function1a"), "13")
        XCTAssertEqual(factory.cardCode(fromInternalName: "function2b"), "14")
        XCTAssertNil(factory.cardCode(fromInternalName: "definitelyNotACard"))
    }
}
