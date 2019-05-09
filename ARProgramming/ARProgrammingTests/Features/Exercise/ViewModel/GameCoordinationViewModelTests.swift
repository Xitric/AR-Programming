//
//  GameCoordinationViewModelTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Level
import EntityComponentSystem
@testable import ARProgramming

class GameCoordinationViewModelTests: XCTestCase {

    private var viewModel: GameCoordinationViewModeling!
    private var currentLevel: CurrentLevelProtocol!

    override func setUp() {
        currentLevel = CurrentLevel()
        viewModel = GameCoordinationViewModel(levelConfig: GradeLevelConfigurationMock(), level: currentLevel)
    }

    // MARK: isFirstLevel
    func testIsFirstLevel_True() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = 1
        currentLevel.level.value = level

        //Act & Assert
        XCTAssertTrue(viewModel.isFirstLevel)
    }

    func testIsFirstLevel_False() {
        //Arrange
        let level = LevelMock()
        level.levelNumber = 5
        currentLevel.level.value = level

        //Act & Assert
        XCTAssertFalse(viewModel.isFirstLevel)
    }
}

private class GradeLevelConfigurationMock: GradeLevelConfiguration {

    func levels(forGrade grade: Int) -> [Int] {
        return [1, 2, 3]
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
