//
//  LevelManagerTests.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 04/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import Level

class LevelManagerTests: XCTestCase {

    private var levelManager: LevelManager!

    // MARK: loadEmptyLevel
    func testLoadEmptyLevel() {
        //Arrange
        let expectation = XCTestExpectation(description: "Empty level loaded")
        levelManager = LevelManager(context: CoreDataRepository(), factories: [EmptyLevelFactory()])

        //Act
        levelManager.loadEmptyLevel { level in
            if level.levelNumber == 0 {
                expectation.fulfill()
            }
        }

        //Assert
        wait(for: [expectation], timeout: 1)
    }

    // MARK: loadItemLevel
    func testLoadItemLevel() {
        //Arrange
        let expectation = XCTestExpectation(description: "Item level loaded")
        levelManager = LevelManager(context: CoreDataRepository(), factories: [CleanUpLevelFactory()])

        //Act
        levelManager.loadItemLevel { level in
            if level.levelNumber == 9000 {
                expectation.fulfill()
            }
        }

        //Assert
        wait(for: [expectation], timeout: 1)
    }

    // MARK: loadLevel
    func testLoadLevel_Success() {
        //Arrange
        let expectation = XCTestExpectation(description: "Level loaded successfully")
        levelManager = LevelManager(context: CoreDataRepository(), factories: [SimpleLevelFactory()])

        //Act
        levelManager.loadLevel(withNumber: 3) { level, _ in
            if let level = level as? LevelStub {
                if level.levelNumber == 3 {
                    expectation.fulfill()
                }
            }
        }

        //Assert
        wait(for: [expectation], timeout: 1)
    }

    func testLoadLevel_InvalidId() {
        //Arrange
        let expectation = XCTestExpectation(description: "Error thrown correctly")
        levelManager = LevelManager(context: CoreDataRepository(), factories: [SimpleLevelFactory()])

        //Act
        levelManager.loadLevel(withNumber: -1) { _, error in
            guard let error = error else { return }
            switch error {
            case LevelLoadingError.noSuchLevel(let number):
                if number == -1 {
                    expectation.fulfill()
                }
            default:
                break
            }
        }

        //Assert
        wait(for: [expectation], timeout: 1)
    }

    func testLoadLevel_FailingFactory() {
        //Arrange
        let expectation = XCTestExpectation(description: "Error thrown correctly")
        levelManager = LevelManager(context: CoreDataRepository(), factories: [FailingLevelFactory()])

        //Act
        levelManager.loadLevel(withNumber: 3) { _, error in
            guard let error = error else { return }
            switch error {
            case LevelLoadingError.badFormat():
                expectation.fulfill()
            default:
                break
            }
        }

        //Assert
        wait(for: [expectation], timeout: 1)
    }

    func testLoadLevel_UnsupportedFormat() {
        //Arrange
        let expectation = XCTestExpectation(description: "Error thrown correctly")
        levelManager = LevelManager(context: CoreDataRepository(), factories: [UnsupportingLevelFactory()])

        //Act
        levelManager.loadLevel(withNumber: 3) { _, error in
            guard let error = error else { return }
            switch error {
            case LevelLoadingError.unsupportedLevelType(_):
                expectation.fulfill()
            default:
                break
            }
        }

        //Assert
        wait(for: [expectation], timeout: 1)
    }
}

// MARK: - Helpers
class SimpleLevelFactory: LevelFactory {
    func canReadLevel(ofType levelType: String) -> Bool {
        return true
    }

    func initLevel(json: Data) throws -> Level {
        guard let jsonLevel = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any],
            let levelNumber = jsonLevel?["number"] as? Int else {
                throw LevelLoadingError.badFormat()
        }

        return LevelStub(number: levelNumber)
    }
}

class FailingLevelFactory: LevelFactory {
    func canReadLevel(ofType levelType: String) -> Bool {
        return true
    }

    func initLevel(json: Data) throws -> Level {
        throw LevelLoadingError.badFormat()
    }
}

class UnsupportingLevelFactory: LevelFactory {
    func canReadLevel(ofType levelType: String) -> Bool {
        return false
    }

    func initLevel(json: Data) throws -> Level {
        throw LevelLoadingError.badFormat()
    }
}

class LevelStub: Level {

    init(number: Int) {
        super.init(name: "", levelNumber: number, levelType: "", unlocks: nil)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
