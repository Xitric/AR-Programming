//
//  CompoundActionTests.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 11/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class CompoundActionTests: XCTestCase {

    private var compoundAction: CompoundAction!
    private var action1: ActionStub!
    private var action2: ActionStub!

    override func setUp() {
        action1 = ActionStub()
        action2 = ActionStub()
        compoundAction = CompoundAction(action1, action2)
    }

    // MARK: run
    func testRunOnEntity() {
        //Arrange
        let callbackExpectation = expectation(description: "Callback called")

        //Act
        compoundAction.run(onEntity: Entity(), withProgramDelegate: nil) {
            callbackExpectation.fulfill()
        }

        //Assert
        wait(for: [action1.runExpectation, action2.runExpectation, callbackExpectation], timeout: 0.1, enforceOrder: true)
    }
}

private class ActionStub: Action {

    let runExpectation = XCTestExpectation(description: "Action was run")

    func run(onEntity entity: Entity, withProgramDelegate delegate: ProgramDelegate?, onCompletion: (() -> Void)?) {
        runExpectation.fulfill()
        onCompletion?()
    }
}
