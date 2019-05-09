//
//  ProgramTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class ProgramTests: XCTestCase {

    private var programNodes: CardNode!
    private var editor: ProgramEditor!
    private var program: Program!
    private var entity: Entity!
    private var manager: EntityManager!

    override func setUp() {
        var currentCard: CardNode = SimpleActionCardNode(name: "move", action: MoveAction())
        programNodes = currentCard

        var nextCard = SimpleActionCardNode(name: "right", action: RotationAction(direction: .right))
        currentCard.addSuccessor(nextCard)
        currentCard = nextCard

        nextCard = SimpleActionCardNode(name: "jump", action: JumpAction())
        currentCard.addSuccessor(nextCard)
        currentCard = nextCard

        editor = ProgramEditor(factory: CardNodeFactory())
        program = Program(startNode: programNodes)
        program.state = editor

        entity = Entity()
        entity.addComponent(TransformComponent())

        manager = EntityManager()
        manager.addEntity(entity)
    }

    private func updateManager() {
        //We need to simulate a queue that continuously updates the entity manager
        let queue = DispatchQueue(label: "dk.sdu.ARProgramming.programTestQueue")
        queue.sync { [unowned self] in
            for _ in 0..<100 {
                self.manager.update(delta: 1)
            }
        }
    }

    // MARK: run
    func testRun_SimpleProgram() {
        //Arrange
        let delegate = TestProgramDelegate(entity: entity, expectedCallbacks: "move", "right", "jump")
        program.delegate = delegate

        //Act
        program.run(on: entity)
        updateManager()

        //Assert
        wait(for: [delegate.startExpectation, delegate.callbackExpectation, delegate.stopExpectation], timeout: 1)
    }
}

private class TestProgramDelegate: ProgramDelegate {

    private var entity: Entity

    var startExpectation: XCTestExpectation
    var stopExpectation: XCTestExpectation
    var callbackExpectation: XCTestExpectation
    private var expectedCards: [String]

    init(entity: Entity, expectedCallbacks: String...) {
        self.entity = entity

        startExpectation = XCTestExpectation(description: "Program delegate started")
        stopExpectation = XCTestExpectation(description: "Program delegate stopped")

        callbackExpectation = XCTestExpectation(description: "Program delegate called")
        callbackExpectation.expectedFulfillmentCount = expectedCallbacks.count
        expectedCards = expectedCallbacks
    }

    func programBegan(_ program: ProgramProtocol) {
        startExpectation.fulfill()
    }

    func program(_ program: ProgramProtocol, willExecute cardNode: CardNodeProtocol) {

    }

    func program(_ program: ProgramProtocol, executed cardNode: CardNodeProtocol) {
        if cardNode.card.internalName == expectedCards.first {
            expectedCards.removeFirst()
            callbackExpectation.fulfill()
        }
    }

    func programEnded(_ program: ProgramProtocol) {
        stopExpectation.fulfill()
    }
}
