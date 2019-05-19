//
//  ExerciseCompletionViewModelTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 11/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Level
import EntityComponentSystem
@testable import ARProgramming

class ExerciseCompletionViewModelTests: XCTestCase {

    private var viewModel: ExerciseCompletionViewModel!
    private var currentLevel: CurrentLevelProtocol!
    private var repository: LevelRepositoryMock!

    override func setUp() {
        currentLevel = CurrentLevel()
        repository = LevelRepositoryMock()
        viewModel = ExerciseCompletionViewModel(level: currentLevel, repository: repository)
    }

    // MARK: hasNextLevel
    func testHasNextLevel_True() {
        //Arrange
        let level = LevelMock()
        level.unlocks = 1
        currentLevel.level.value = level

        viewModel = ExerciseCompletionViewModel(level: currentLevel, repository: repository)

        //Act & Assert
        XCTAssertTrue(viewModel.hasNextLevel)
    }

    func testHasNextLevel_False() {
        //Arrange
        currentLevel.level.value = LevelMock()

        viewModel = ExerciseCompletionViewModel(level: currentLevel, repository: repository)

        //Act & Assert
        XCTAssertFalse(viewModel.hasNextLevel)
    }

    func testHasNextLevel_NoLevel() {
        //Act & Assert
        XCTAssertFalse(viewModel.hasNextLevel)
    }

    // MARK: reset
    func testReset() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = 4
        currentLevel.level.value = level

        let newLevel = LevelMock()
        newLevel.levelNumber = level.levelNumber
        repository.levelToLoad = newLevel

        //Act
        viewModel.reset()

        //Assert
        currentLevel.level.waitForValueUpdate()
        XCTAssertTrue(currentLevel.level.value === newLevel)
        wait(for: [repository.loadExpectation], timeout: 0.1)
    }

    func testReset_NoLevel() {
        //Arrange
        repository.loadExpectation.isInverted = true

        //Act
        viewModel.reset()

        //Assert
        currentLevel.level.ensureNotUpdated()
        wait(for: [repository.loadExpectation], timeout: 0.1)
    }

    func testReset_InvalidId() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = -1
        currentLevel.level.value = level

        //Act
        viewModel.reset()

        //Assert
        currentLevel.level.ensureNotUpdated()
        wait(for: [repository.loadExpectation], timeout: 0.1)
    }

    // MARK: goToNext
    func testGoToNext() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = 4
        level.unlocks = 5
        currentLevel.level.value = level

        let newLevel = LevelMock()
        newLevel.levelNumber = level.unlocks!
        repository.levelToLoad = newLevel

        //Act
        viewModel.goToNext()

        //Assert
        currentLevel.level.waitForValueUpdate()
        XCTAssertTrue(currentLevel.level.value === newLevel)
        wait(for: [repository.loadExpectation], timeout: 0.1)
    }

    func testGoToNext_NoLevel() {
        //Arrange
        repository.loadExpectation.isInverted = true

        //Act
        viewModel.goToNext()

        //Assert
        currentLevel.level.ensureNotUpdated()
        wait(for: [repository.loadExpectation], timeout: 0.1)
    }

    func testGoToNext_LastLevel() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = 4
        currentLevel.level.value = level

        repository.loadExpectation.isInverted = true

        //Act
        viewModel.goToNext()

        //Assert
        currentLevel.level.ensureNotUpdated()
        wait(for: [repository.loadExpectation], timeout: 0.1)
    }

    func testGoToNext_InvalidId() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = 4
        level.unlocks = -1
        currentLevel.level.value = level

        //Act
        viewModel.goToNext()

        //Assert
        currentLevel.level.ensureNotUpdated()
        wait(for: [repository.loadExpectation], timeout: 0.1)
    }
}

private class LevelMock: LevelProtocol {

    var name = ""
    var levelNumber = 0
    var levelType = ""
    var unlocked = true
    var unlocks: Int?
    var infoLabel: String?
    var entityManager = EntityManager()
    weak var delegate: LevelDelegate?

    func update(currentTime: TimeInterval) {
        //Ignored
    }

    func isComplete() -> Bool {
        return false
    }
}

private class LevelRepositoryMock: LevelRepository {

    var levelToLoad: LevelProtocol?
    var loadExpectation = XCTestExpectation(description: "Load level called")

    func loadEmptyLevel(completion: @escaping (LevelProtocol) -> Void) {
        //Ignored
    }

    func loadItemLevel(completion: @escaping (LevelProtocol) -> Void) {
        //Ignored
    }

    func loadLevel(withNumber id: Int, completion: @escaping (LevelProtocol?, LevelLoadingError?) -> Void) {
        loadExpectation.fulfill()
        if id == levelToLoad?.levelNumber {
            completion(levelToLoad!, nil)
        } else {
            completion(nil, LevelLoadingError.noSuchLevel(levelNumber: id))
        }
    }

    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?) {
        //Ignored
    }

    func loadPreviews(forLevels levelIds: [Int], completion: @escaping ([LevelInfoProtocol]?, LevelLoadingError?) -> Void) {
        //Ignored
    }
}

//let hasNextLevel: Bool
//
//init(level: CurrentLevelProtocol, repository: LevelRepository) {
//    self.levelContainer = level
//    self.repository = repository
//
//    hasNextLevel = levelContainer.level.value?.unlocks != nil
//}
//
//func reset() {
//    if let levelNumber = levelContainer.level.value?.levelNumber {
//        repository.loadLevel(withNumber: levelNumber) { [weak self] level, _ in
//            self?.handleLevelLoaded(level: level)
//        }
//    }
//}
//
//func goToNext() {
//    if let nextLevelNumber = levelContainer.level.value?.unlocks {
//        repository.loadLevel(withNumber: nextLevelNumber) { [weak self] level, _ in
//            self?.handleLevelLoaded(level: level)
//        }
//    }
//}
//
//private func handleLevelLoaded(level: LevelProtocol?) {
//    if let level = level {
//        DispatchQueue.main.async { [weak self] in
//            self?.levelContainer.level.value = level
//        }
//    }
//}
//}
