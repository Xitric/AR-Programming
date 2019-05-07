//
//  CardCollectionViewModelTests.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 07/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Swinject
import ProgramModel
@testable import ARProgramming

class CardCollectionViewModelTests: XCTestCase {

    private var viewModel: CardCollectionViewModel!

    override func setUp() {
        let container = Container()
        container.addProgram()
        let cardCollection = container.resolve(CardCollection.self)
        let config = CardConfig()
        viewModel = CardCollectionViewModel(cardCollection: cardCollection!, configuration: config)
    }

    func testSetGrade_1() {
        // Act
        viewModel.setGrade(grade: 1)

        // Assert
        XCTAssertEqual(viewModel.numberOfTypes, 2)
        XCTAssertEqual(viewModel.cardTypes, [.action, .control])
    }

    func testSetGrade_2() {
        // Act
        viewModel.setGrade(grade: 2)

        // Assert
        XCTAssertEqual(viewModel.numberOfTypes, 3)
        XCTAssertEqual(viewModel.cardTypes, [.action, .control, .parameter])
    }

    func testSetGrade_3() {
        // Act
        viewModel.setGrade(grade: 3)

        // Assert
        XCTAssertEqual(viewModel.numberOfTypes, 3)
        XCTAssertEqual(viewModel.cardTypes, [.action, .control, .parameter])
    }

    func testSetGrade_4() {
        // Act
        viewModel.setGrade(grade: 4)

        // Assert
        XCTAssertEqual(viewModel.numberOfTypes, 3)
        XCTAssertEqual(viewModel.cardTypes, [.action, .control, .parameter])
    }

    func testSetGrade_invalid() {
        // Act
        viewModel.setGrade(grade: 0)

        // Assert
        XCTAssertEqual(viewModel.numberOfTypes, 0)
        XCTAssertEqual(viewModel.cardTypes, [])
    }

    func testNumberOfCardsOfType_1() {
        // Arrange
        viewModel.setGrade(grade: 1)

        // Act
        let numberOfActions = viewModel.numberOfCards(ofType: .action)
        let numberOfControls = viewModel.numberOfCards(ofType: .control)
        let numberOfParameters = viewModel.numberOfCards(ofType: .parameter)

        // Assert
        XCTAssertEqual(numberOfActions, 4)
        XCTAssertEqual(numberOfControls, 1)
        XCTAssertEqual(numberOfParameters, 0)
    }

    func testNumberOfCardsOfType_2() {
        // Arrange
        viewModel.setGrade(grade: 2)

        // Act
        let numberOfActions = viewModel.numberOfCards(ofType: .action)
        let numberOfControls = viewModel.numberOfCards(ofType: .control)
        let numberOfParameters = viewModel.numberOfCards(ofType: .parameter)

        // Assert
        XCTAssertEqual(numberOfActions, 4)
        XCTAssertEqual(numberOfControls, 3)
        XCTAssertEqual(numberOfParameters, 4)
    }

    func testNumberOfCardsOfType_3() {
        // Arrange
        viewModel.setGrade(grade: 3)

        // Act
        let numberOfActions = viewModel.numberOfCards(ofType: .action)
        let numberOfControls = viewModel.numberOfCards(ofType: .control)
        let numberOfParameters = viewModel.numberOfCards(ofType: .parameter)

        // Assert
        XCTAssertEqual(numberOfActions, 6)
        XCTAssertEqual(numberOfControls, 7)
        XCTAssertEqual(numberOfParameters, 4)
    }

    func testNumberOfCardsOfType_4() {
        // Arrange
        viewModel.setGrade(grade: 4)

        // Act
        let numberOfActions = viewModel.numberOfCards(ofType: .action)
        let numberOfControls = viewModel.numberOfCards(ofType: .control)
        let numberOfParameters = viewModel.numberOfCards(ofType: .parameter)

        // Assert
        XCTAssertEqual(numberOfActions, 6)
        XCTAssertEqual(numberOfControls, 7)
        XCTAssertEqual(numberOfParameters, 4)
    }

    func testNumberOfCardsOfType_invalid() {
        // Arrange
        viewModel.setGrade(grade: 0)

        // Act
        let numberOfActions = viewModel.numberOfCards(ofType: .action)
        let numberOfControls = viewModel.numberOfCards(ofType: .control)
        let numberOfParameters = viewModel.numberOfCards(ofType: .parameter)

        // Assert
        XCTAssertEqual(numberOfActions, 0)
        XCTAssertEqual(numberOfControls, 0)
        XCTAssertEqual(numberOfParameters, 0)
    }

    func testCardsOfType_1() {
        // Arrange
        viewModel.setGrade(grade: 1)
        let actionCards = ["jump", "left", "move", "right"]
        let controlCards = ["function0a"]
        let parameterCards: [String] = []

        // Act
        actionContainsArray(type: .action, cardNames: actionCards)
        actionContainsArray(type: .control, cardNames: controlCards)
        actionContainsArray(type: .parameter, cardNames: parameterCards)
    }

    func testCardsOfType_2() {
        // Arrange
        viewModel.setGrade(grade: 2)
        let actionCards = ["jump", "left", "move", "right"]
        let controlCards = ["block", "loop", "function0a"]
        let parameterCards = ["param1", "param2", "param3", "param4"]

        // Act
        actionContainsArray(type: .action, cardNames: actionCards)
        actionContainsArray(type: .control, cardNames: controlCards)
        actionContainsArray(type: .parameter, cardNames: parameterCards)
    }

    func testCardsOfType_3() {
        // Arrange
        viewModel.setGrade(grade: 3)
        let actionCards = ["drop", "jump", "left", "move", "right", "pickup"]
        let controlCards = ["block", "function0a", "function1a", "function2a", "function3a", "function4a", "loop"]
        let parameterCards = ["param1", "param2", "param3", "param4"]

        // Act
        actionContainsArray(type: .action, cardNames: actionCards)
        actionContainsArray(type: .control, cardNames: controlCards)
        actionContainsArray(type: .parameter, cardNames: parameterCards)
    }

    func testCardsOfType_4() {
        // Arrange
        viewModel.setGrade(grade: 4)
        let actionCards = ["drop", "jump", "left", "move", "right", "pickup"]
        let controlCards = ["block", "function0a", "function1a", "function2a", "function3a", "function4a", "loop"]
        let parameterCards = ["param1", "param2", "param3", "param4"]

        // Act
        actionContainsArray(type: .action, cardNames: actionCards)
        actionContainsArray(type: .control, cardNames: controlCards)
        actionContainsArray(type: .parameter, cardNames: parameterCards)
    }

    func testCardsOfType_invalid() {
        // Arrange
        viewModel.setGrade(grade: 0)
        let actionCards: [String] = []
        let controlCards: [String] = []
        let parameterCards: [String] = []

        // Act
        actionContainsArray(type: .action, cardNames: actionCards)
        actionContainsArray(type: .control, cardNames: controlCards)
        actionContainsArray(type: .parameter, cardNames: parameterCards)
    }

    func testDisplayName() {
        // Act
        let actionString = viewModel.displayName(ofType: .action)
        let controlString = viewModel.displayName(ofType: .control)
        let parameterString = viewModel.displayName(ofType: .parameter)

        // Assert
        XCTAssertEqual(actionString, "Handlinger")
        XCTAssertEqual(controlString, "Kontrol")
        XCTAssertEqual(parameterString, "Talkort")
    }

    private func actionContainsArray (type: CardType, cardNames: [String]) {

        let numberOfCardsForType = viewModel.cards(ofType: type)

        // Assert
        for name in cardNames {
           XCTAssertTrue(numberOfCardsForType.contains {
                $0.internalName == name
            })
        }
    }
}
