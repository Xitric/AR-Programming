//
//  GradeCardConfigurationTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Swinject
import ProgramModel
@testable import ARProgramming

class GradeCardConfigurationTests: XCTestCase {

    private var config: GradeCardConfiguration!
    private var allCards: [Card]!

    override func setUp() {
        config = CardConfig()

        let container = Container()
        container.addProgram()
        allCards = container.resolve(CardCollection.self)?.cards
    }

    func testIsIncluded_InMinimumGrade() {
        XCTAssertTrue(config.isIncluded(cardName: "move", forGrade: 1))

        XCTAssertFalse(config.isIncluded(cardName: "loop", forGrade: 1))
        XCTAssertTrue(config.isIncluded(cardName: "loop", forGrade: 2))

        XCTAssertFalse(config.isIncluded(cardName: "function3a", forGrade: 2))
        XCTAssertTrue(config.isIncluded(cardName: "function3a", forGrade: 3))
    }

    func testIsIncluded_InLaterGrade() {
        XCTAssertTrue(config.isIncluded(cardName: "move", forGrade: 2))
        XCTAssertTrue(config.isIncluded(cardName: "move", forGrade: 3))
        XCTAssertTrue(config.isIncluded(cardName: "move", forGrade: 4))
    }

    func testIsIncluded_InvalidGrade() {
        XCTAssertFalse(config.isIncluded(cardName: "move", forGrade: 0))
    }

    func testIsIncluded_AllCards() {
        //The sending function cards are not included in the library
        for card in allCards where !card.internalName.contains("1b") &&
            !card.internalName.contains("2b") &&
            !card.internalName.contains("3b") &&
            !card.internalName.contains("4b") {
            XCTAssertTrue(config.isIncluded(cardName: card.internalName, forGrade: 4))
        }
    }
}
