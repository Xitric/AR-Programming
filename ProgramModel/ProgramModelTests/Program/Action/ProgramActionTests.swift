//
//  ProgramActionTests.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class ProgramActionTests: XCTestCase {

    private var action: ProgramAction!
    private var program: ProgramMock!

    override func setUp() {
        program = ProgramMock()
        action = ProgramAction(program: program)
    }

    // MARK: run
    func testRun_Simple() {
        //Act
        action.run(onEntity: Entity(), withProgramDelegate: nil, onCompletion: nil)

        //Assert
        wait(for: [program.runExpectation], timeout: 0.1)
    }

    // MARK: programWillExecute
    func testProgramWillExecute() {
        //Arrange
        let delegate = ProgramDelegateMock()
        delegate.expectedCard = "loop"
        action.run(onEntity: Entity(), withProgramDelegate: delegate, onCompletion: nil)

        //Act
        program.delegate?.program(program, willExecute: LoopCardNode())

        //Assert
        wait(for: [delegate.cardExpectation], timeout: 0.1)
    }

    // MARK: programExecuted
    func testProgramExecuted() {
        //Arrange
        let delegate = ProgramDelegateMock()
        delegate.expectedCard = "loop"
        action.run(onEntity: Entity(), withProgramDelegate: delegate, onCompletion: nil)

        //Act
        program.delegate?.program(program, executed: LoopCardNode())

        //Assert
        wait(for: [delegate.cardExpectation], timeout: 0.1)
    }

    // MARK: programEnded
    func testProgramEnded() {
        //Arrange
        let delegate = ProgramDelegateMock()
        let completionExpectation = XCTestExpectation(description: "Function completion called")
        let onCompletion = {
            completionExpectation.fulfill()
        }
        action.run(onEntity: Entity(), withProgramDelegate: delegate, onCompletion: onCompletion)

        //Act
        program.delegate?.programEnded(program)

        //Assert
        wait(for: [completionExpectation], timeout: 0.1)
    }
}

private class ProgramMock: ProgramProtocol {

    var runExpectation = XCTestExpectation(description: "Run was called on program")
    weak var delegate: ProgramDelegate?
    var start: CardNodeProtocol?

    func run(on entity: Entity) {
        runExpectation.fulfill()
    }
}

private class ProgramDelegateMock: ProgramDelegate {

    var expectedCard: String? {
        didSet {
            cardExpectation = XCTestExpectation(description: "Card callback")
        }
    }
    var cardExpectation: XCTestExpectation!

    func programBegan(_ program: ProgramProtocol) {
        //Ignored
    }

    func program(_ program: ProgramProtocol, willExecute cardNode: CardNodeProtocol) {
        if cardNode.card.internalName == expectedCard {
            cardExpectation.fulfill()
        }
    }

    func program(_ program: ProgramProtocol, executed cardNode: CardNodeProtocol) {
        if cardNode.card.internalName == expectedCard {
            cardExpectation.fulfill()
        }
    }

    func programEnded(_ program: ProgramProtocol) {
        //Ignored
    }
}
