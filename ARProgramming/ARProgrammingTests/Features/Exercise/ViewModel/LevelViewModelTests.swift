//
//  LevelViewModelTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Level
import EntityComponentSystem
@testable import ARProgramming

class LevelViewModelTests: XCTestCase {

    private var viewModel: LevelViewModel!
    private var currentLevel: CurrentLevelProtocol!
    private var levelRepository: LevelRespositoryMock!
    private var scoreManager: ScoreMock!

    override func setUp() {
        currentLevel = CurrentLevel()
        levelRepository = LevelRespositoryMock()
        scoreManager = ScoreMock()
        viewModel = LevelViewModel(level: currentLevel, levelRepository: levelRepository, scoreManager: scoreManager)
    }

    // MARK: init
    func testInit() {
        //Assert
        XCTAssertFalse(viewModel.complete.value)
        XCTAssertNil(viewModel.levelInfo.value)

        //Arrange
        let level = LevelMock()
        level.complete = true
        level.infoLabel = "This is the info"

        //Act
        currentLevel.level.value = level

        //Assert
        XCTAssertTrue(level.delegate === viewModel)
        XCTAssertTrue(viewModel.complete.value)
        XCTAssertEqual(viewModel.levelInfo.value, level.infoLabel)
    }

    // MARK: level
    func testLevel() {
        //Assert
        XCTAssertNil(viewModel.level.value)

        //Arrange
        let level1 = LevelMock()

        //Act
        currentLevel.level.value = level1

        //Assert
        XCTAssertTrue(viewModel.level.value === level1)

        //Arrange
        let level2 = LevelMock()

        //Act
        currentLevel.level.value = level2

        //Assert
        XCTAssertTrue(viewModel.level.value === level2)
    }

    // MARK: complete
    func testComplete() {
        //Assert
        XCTAssertFalse(viewModel.complete.value)

        //Arrange
        let level = LevelMock()
        currentLevel.level.value = level

        //Act
        level.delegate?.levelCompleted(level)

        //Assert
        viewModel.complete.waitForValueUpdate()
        XCTAssertTrue(viewModel.complete.value)
    }

    func testComplete_Reset() {
        //Arrange
        let level = LevelMock()
        level.complete = true
        currentLevel.level.value = level

        //Assert
        XCTAssertTrue(viewModel.complete.value)

        //Act
        viewModel.reset()

        //Assert
        viewModel.complete.waitForValueUpdate()
        XCTAssertFalse(viewModel.complete.value)
    }

    // MARK: levelInfo
    func testLevelInfo() {
        //Assert
        XCTAssertNil(viewModel.levelInfo.value)

        //Arrange
        let level = LevelMock()
        currentLevel.level.value = level

        //Act
        level.infoLabel = "New label"
        level.delegate?.levelInfoChanged(level, info: level.infoLabel)

        //Assert
        viewModel.levelInfo.waitForValueUpdate()
        XCTAssertEqual(viewModel.levelInfo.value, level.infoLabel)
    }

    func testLevelInfo_Reset() {
        //Arrange
        let level = LevelMock()
        level.infoLabel = "Info label"
        currentLevel.level.value = level

        //Assert
        XCTAssertEqual(viewModel.levelInfo.value, level.infoLabel)

        //Act
        viewModel.reset()

        //Assert
        viewModel.levelInfo.waitForValueUpdate()
        XCTAssertNil(viewModel.levelInfo.value)
    }

    // MARK: player
    func testPlayer() {
        //Assert
        XCTAssertNil(viewModel.player)

        //Arrange
        let level = LevelMock()

        //Act
        currentLevel.level.value = level

        //Assert
        XCTAssertNotNil(viewModel.player)
        XCTAssertEqual(viewModel.player, level.entityManager.player)
    }

    // MARK: reset
    func testReset_Score() {
        //Arrange
        let level = LevelMock()
        currentLevel.level.value = level
        viewModel.scoreUpdated(newScore: 1)
        viewModel.scoreUpdated(newScore: 2)
        XCTAssertEqual(scoreManager.score, 2)

        //Act
        viewModel.reset()

        //Assert
        viewModel.level.waitForValueUpdate()
        XCTAssertEqual(scoreManager.score, 0)
    }

    func testReset_Failed() {
        //Arrange
        let level = LevelMock()
        currentLevel.level.value = level

        //Assert
        XCTAssertTrue(viewModel.level.value === level)

        //Arrange
        levelRepository.shouldLoadFail = true

        //Act
        viewModel.reset()

        //Assert
        viewModel.level.ensureNotUpdated()
        XCTAssertTrue(viewModel.level.value === level)
    }

    // MARK: scoreUpdated
    func testScoreUpdated() {
        //Assert
        XCTAssertEqual(scoreManager.score, 0)

        //Act
        viewModel.scoreUpdated(newScore: 1)

        //Assert
        XCTAssertEqual(scoreManager.score, 1)

        //Act
        viewModel.scoreUpdated(newScore: 2)

        //Assert
        XCTAssertEqual(scoreManager.score, 2)
    }

    // MARK: levelCompleted
    func testLevelCompleted_Score() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = 5
        currentLevel.level.value = level
        scoreManager.expectedComputeId = level.levelNumber

        //Act
        level.delegate?.levelCompleted(level)

        //Assert
        wait(for: [scoreManager.computeExpectation], timeout: 0.1)
    }
}

private class LevelMock: LevelProtocol {

    var name = ""
    var levelNumber = 0
    var levelType = ""
    var complete = false
    var unlocked = true
    var unlocks: Int?
    var infoLabel: String?
    var entityManager = EntityManager()
    weak var delegate: LevelDelegate?

    func update(currentTime: TimeInterval) {
        //Ignored
    }

    func isComplete() -> Bool {
        return complete
    }
}

private class LevelRespositoryMock: LevelRepository {

    var shouldLoadFail = false

    func loadEmptyLevel(completion: @escaping (LevelProtocol) -> Void) {
        //Ignored
    }

    func loadItemLevel(completion: @escaping (LevelProtocol) -> Void) {
        //Ignored
    }

    func loadLevel(withNumber id: Int, completion: @escaping (LevelProtocol?, LevelLoadingError?) -> Void) {
        if shouldLoadFail {
            completion(nil, LevelLoadingError.noSuchLevel(levelNumber: id))
        } else {
            completion(LevelMock(), nil)
        }
    }

    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?) {
        //Ignored
    }

    func loadPreviews(forLevels levelIds: [Int], completion: @escaping ([LevelInfoProtocol]?, LevelLoadingError?) -> Void) {
        //Ignored
    }
}

private class ScoreMock: ScoreProtocol {

    var score = 0
    var computeExpectation = XCTestExpectation(description: "Compute score was called")
    var expectedComputeId: Int?

    func incrementCardCount() {
        score += 1
    }

    func resetScore() {
        score = 0
    }

    func computeScore(level: Int) {
        if level == expectedComputeId {
            computeExpectation.fulfill()
        }
    }

    func getScore(forLevel: Int) -> Int {
        return score
    }
}
