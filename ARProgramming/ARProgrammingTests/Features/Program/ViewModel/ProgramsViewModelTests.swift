//
//  ProgramsViewModelTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 04/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import ProgramModel
import EntityComponentSystem
@testable import ARProgramming

class ProgramsViewModelTests: XCTestCase {

    private var viewModel: ProgramsViewModel!
    private var editor: ProgramEditorMock!
    private weak var main: ProgramStub!

    override func setUp() {
        let main = ProgramStub()
        self.main = main
        editor = ProgramEditorMock(main: main)
        viewModel = ProgramsViewModel(editor: editor)
    }

    // MARK: running
    func testRunning() {
        //Act & Assert
        XCTAssertFalse(viewModel.running.value)

        //Arrange
        viewModel.start(on: Entity())
        XCTAssertNotNil(main.delegate)
        main.delegate?.programBegan(main)

        //Act & Assert
        viewModel.running.waitForValueUpdate()
        XCTAssertTrue(viewModel.running.value)

        //Arrange
        main.delegate?.programEnded(main)

        //Act & Assert
        viewModel.running.waitForValueUpdate()
        XCTAssertFalse(viewModel.running.value)
    }

    func testRunning_Reset() {
        //Arrange
        viewModel.start(on: Entity())
        XCTAssertNotNil(main.delegate)
        main.delegate?.programBegan(main)

        //Act & Assert
        viewModel.running.waitForValueUpdate()
        XCTAssertTrue(viewModel.running.value)

        //Arrange
        viewModel.reset()

        //Act & Assert
        XCTAssertFalse(viewModel.running.value)
        XCTAssertNil(main)
    }

    // MARK: activeCard
    func testActiveCard() {
        //Act & Assert
        XCTAssertNil(viewModel.activeCard.value)

        //Arrange
        viewModel.start(on: Entity())
        XCTAssertNotNil(main.delegate)
        let node = CardNodeStub()
        main.delegate?.program(main, willExecute: node)

        //Act & Assert
        viewModel.activeCard.waitForValueUpdate()
        XCTAssertTrue(viewModel.activeCard.value === node)

        //Arrange
        main.delegate?.program(main, executed: node)

        //Act & Assert
        viewModel.activeCard.waitForValueUpdate()
        XCTAssertNil(viewModel.activeCard.value)
    }

    func testActiveCard_Reset() {
        //Arrange
        viewModel.start(on: Entity())
        let node = CardNodeStub()
        main.delegate?.program(main, willExecute: node)
        viewModel.activeCard.waitForValueUpdate()
        XCTAssertNotNil(viewModel.activeCard.value)

        //Act
        viewModel.reset()

        //Assert
        XCTAssertNil(viewModel.activeCard.value)
    }

    // MARK: main
    func testMain_Initial() {
        //Assert
        XCTAssertTrue(viewModel.main.value === main)
    }

    func testMain_NewProgram() {
        //Arrange
        let newMain = ProgramStub()
        editor.main = newMain

        //Act
        viewModel.add(program: newMain)

        //Assert
        XCTAssertTrue(viewModel.main.value === newMain)
    }

    func testMain_Reset() {
        //Arrange
        let oldMain = editor.main

        //Act
        viewModel.reset()

        //Assert
        XCTAssertFalse(viewModel.main.value === oldMain)
        XCTAssertTrue(viewModel.main.value === editor.main)
    }

    // MARK: executedCards
    func testExecutedCards() {
        //Assert
        XCTAssertEqual(viewModel.executedCards.value, 0)

        //Arrange
        viewModel.start(on: Entity())
        let node1 = CardNodeStub()
        main.delegate?.program(main, willExecute: node1)

        //Assert
        viewModel.executedCards.waitForValueUpdate()
        XCTAssertEqual(viewModel.executedCards.value, 1)

        //Arrange
        viewModel.start(on: Entity())
        main.delegate?.program(main, executed: node1)
        let node2 = CardNodeStub()
        main.delegate?.program(main, willExecute: node2)

        //Assert
        viewModel.executedCards.waitForValueUpdate()
        XCTAssertEqual(viewModel.executedCards.value, 2)
    }

    func testExecutedCards_Restart() {
        //Arrange
        viewModel.start(on: Entity())
        let node1 = CardNodeStub()
        main.delegate?.program(main, willExecute: node1)

        //Assert
        viewModel.executedCards.waitForValueUpdate()
        XCTAssertEqual(viewModel.executedCards.value, 1)

        //Arrange
        main.delegate?.programBegan(main)

        //Assert
        viewModel.executedCards.waitForValueUpdate()
        XCTAssertEqual(viewModel.executedCards.value, 0)
    }

    func testExecutedCards_Reset() {
        //Arrange
        viewModel.start(on: Entity())
        let node1 = CardNodeStub()
        main.delegate?.program(main, willExecute: node1)

        //Assert
        viewModel.executedCards.waitForValueUpdate()
        XCTAssertEqual(viewModel.executedCards.value, 1)

        //Arrange
        viewModel.reset()

        //Assert
        XCTAssertEqual(viewModel.executedCards.value, 0)
    }

    // MARK: start
    func testStart() {
        //Act
        viewModel.start(on: Entity())

        //Assert
        XCTAssertNotNil(main.delegate)
        wait(for: [main.runExpectation], timeout: 0.1)
    }
}

private class ProgramEditorMock: ProgramEditorProtocol {

    weak var delegate: ProgramEditorDelegate?
    var main: ProgramProtocol
    var allPrograms = [ProgramProtocol]()
    var allCards = [CardNodeProtocol]()

    init(main: ProgramProtocol) {
        self.main = main
    }

    func save(_ program: ProgramProtocol) {
        allPrograms.append(program)
    }

    func reset() {
        allPrograms.removeAll()
        main = ProgramStub()
    }

    func newFrame(_ frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation, frameWidth: Double, frameHeight: Double) {
        //Ignore
    }
}

private class ProgramStub: ProgramProtocol {

    let runExpectation = XCTestExpectation(description: "Program run method called")

    weak var delegate: ProgramDelegate?
    var start: CardNodeProtocol?

    func run(on entity: Entity) {
        runExpectation.fulfill()
    }
}

private class CardNodeStub: CardNodeProtocol {
    var position = simd_double2(0, 0)
    var size = simd_double2(0, 0)
    var entryAngle = 0.0
    var children = [CardNodeProtocol]()
    var card: Card = CardStub()
}

private struct CardStub: Card {
    var internalName = ""
    var type = CardType.action
    var supportsParameter = false
    var requiresParameter = false
    var connectionAngles = [Double]()
}

private extension ImmutableObservableProperty {

    func waitForValueUpdate() {
        let expectation = XCTestExpectation(description: "Observable value updated")
        let observer = observeFuture { _ in
            expectation.fulfill()
        }

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        observer.release()

        switch result {
        case .completed:
            return
        default:
            XCTFail("Something went wrong when waiting for property value to be updated")
        }
    }
}
