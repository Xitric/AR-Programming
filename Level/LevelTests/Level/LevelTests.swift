//
//  LevelTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import Level

class LevelTests: XCTestCase {

    private var level: LevelMock!

    override func setUp() {
        level = SimpleLevelLoader.loadLevel(ofType: LevelMock.self, withName: "TestLevel.json")
        level.expectedDelta = 5
    }

    // MARK: init
    func testInit() {
        //Assert
        XCTAssertNotNil(level)
        XCTAssertEqual(level?.levelType, "quantity")
        XCTAssertEqual(level?.name, "Test Level")
        XCTAssertEqual(level?.levelNumber, 0)
        XCTAssertEqual(level?.unlocked, false)
        XCTAssertEqual(level?.unlocks, 5)
        XCTAssertNil(level!.infoLabel)

        let entities = level?.entityManager.getEntities(withComponents: TransformComponent.self)
        XCTAssertEqual(entities?.count, 3)

        let props = entities?.filter {
            $0 !== level?.entityManager.player
        }
        XCTAssertEqual(props?.count, 2)
    }

    // MARK: update
    func testUpdate() {
        //Act
        level.update(currentTime: 5)

        //Assert
        wait(for: [level.updateExpectation], timeout: 0.1)
    }

    func testUpdate_SecondTime() {
        //Arrange
        level.update(currentTime: 10)

        //Act
        level.update(currentTime: 15)

        //Assert
        wait(for: [level.updateExpectation], timeout: 0.1)
    }

    // MARK: complete
    func testComplete() {
        //Arrange
        let repository = LevelRepositoryMock()
        repository.expectedLevelId = level.unlocks
        level.levelRepository = repository

        let delegate = LevelDelegateMock()
        level.delegate = delegate

        //Act
        level.complete()

        //Assert
        wait(for: [repository.markExpectation, delegate.completeExpectation], timeout: 0.1, enforceOrder: true)
    }

    func testComplete_UnlocksNothing() {
        //Arrange
        let unlocksNilLevel = Level(name: "", levelNumber: 0, levelType: "", unlocks: nil)

        let repository = LevelRepositoryMock()
        repository.markExpectation.isInverted = true
        unlocksNilLevel.levelRepository = repository

        let delegate = LevelDelegateMock()
        unlocksNilLevel.delegate = delegate

        //Act
        unlocksNilLevel.complete()

        //Assert
        wait(for: [repository.markExpectation, delegate.completeExpectation], timeout: 0.1)
    }
}

private class LevelMock: Level {

    let updateExpectation = XCTestExpectation(description: "Update with delta called")
    var expectedDelta: Double?

    override func update(delta: TimeInterval) {
        if delta == expectedDelta {
            updateExpectation.fulfill()
        }
    }
}

private class LevelRepositoryMock: LevelRepository {

    let markExpectation = XCTestExpectation(description: "Mark level called")
    var expectedLevelId: Int?

    func loadEmptyLevel(completion: @escaping (LevelProtocol) -> Void) {
        //Ignored
    }

    func loadItemLevel(completion: @escaping (LevelProtocol) -> Void) {
        //Ignored
    }

    func loadLevel(withNumber id: Int, completion: @escaping (LevelProtocol?, LevelLoadingError?) -> Void) {
        //Ignored
    }

    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?) {
        if id == expectedLevelId && unlocked {
            markExpectation.fulfill()
        }
    }

    func loadPreviews(forLevels levelIds: [Int], completion: @escaping ([LevelInfoProtocol]?, LevelLoadingError?) -> Void) {
        //Ignored
    }
}

private class LevelDelegateMock: LevelDelegate {

    let completeExpectation = XCTestExpectation(description: "Level delegate completion called")

    func levelCompleted(_ level: LevelProtocol) {
        completeExpectation.fulfill()
    }

    func levelInfoChanged(_ level: LevelProtocol, info: String?) {
        //Ignored
    }
}
