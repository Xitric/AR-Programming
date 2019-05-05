//
//  FunctionCardNodeTests.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class FunctionCardNodeTests: XCTestCase {

    private var caller: FunctionCardNode!
    private var receiver: FunctionCardNode!
    private var state: ProgramStateMock!

    override func setUp() {
        caller = FunctionCardNode(functionNumber: 2, isCaller: true)
        receiver = FunctionCardNode(functionNumber: 2, isCaller: false)
        state = ProgramStateMock(receiver: receiver)
    }

    // MARK: init
    func testInit() {
        //Assert
        XCTAssertEqual(caller.card.internalName, "function2b")
        XCTAssertEqual(caller.card.type, .control)
        XCTAssertEqual(receiver.card.internalName, "function2a")
    }

    // MARK: getAction
    func testGetAction_Caller() {
        //Act
        let result = caller.getAction(forEntity: Entity(), withProgramState: state)

        //Assert
        wait(for: [state.expectation], timeout: 0.1)
        XCTAssertTrue(result is CompoundAction)
    }

    func testGetAction_Receiver() {
        //Act
        let result = receiver.getAction(forEntity: Entity(), withProgramState: state)

        //Assert
        XCTAssertTrue(result is WaitAction)
    }
}

private class ProgramStateMock: ProgramState {

    private let receiver: FunctionCardNode
    let expectation = XCTestExpectation(description: "Get program was called")

    init(receiver: FunctionCardNode) {
        self.receiver = receiver
    }

    func getProgram(forCardWithName internalName: String) -> ProgramProtocol? {
        if internalName == receiver.card.internalName {
            expectation.fulfill()
            return Program(startNode: receiver)
        }

        return nil
    }
}
