//
//  ExampleProgramViewModelTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 11/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import Level
import EntityComponentSystem
@testable import ARProgramming

class ExampleProgramViewModelTests: XCTestCase {

    private var viewModel: ExampleProgramViewModel!
    private var currentLevel: CurrentLevelProtocol!
    private var emptyLevel: LevelProtocol!
    private var itemLevel: LevelProtocol!
    private var repository: LevelRepositoryMock!

    override func setUp() {
        currentLevel = CurrentLevel()

        emptyLevel = LevelMock(id: 0)
        itemLevel = LevelMock(id: 1)
        repository = LevelRepositoryMock(emptyLevel: emptyLevel, itemLevel: itemLevel)

        viewModel = ExampleProgramViewModel(level: currentLevel, levelRepository: repository)
    }

    // MARK: cardName
    func testCardName_Pickup() {
        //Act
        viewModel.cardName.value = "pickup"

        //Assert
        currentLevel.level.waitForValueUpdate()
        XCTAssertTrue(currentLevel.level.value === itemLevel)
        XCTAssertTrue(viewModel.player === itemLevel.entityManager.player)
    }

    func testCardName_Drop() {
        //Act
        viewModel.cardName.value = "drop"

        //Assert
        currentLevel.level.waitForValueUpdate()
        XCTAssertTrue(currentLevel.level.value === itemLevel)
        XCTAssertTrue(viewModel.player === itemLevel.entityManager.player)
    }

    func testCardName_Default() {
        //Act
        viewModel.cardName.value = "move"

        //Assert
        currentLevel.level.waitForValueUpdate()
        XCTAssertTrue(currentLevel.level.value === emptyLevel)
        XCTAssertTrue(viewModel.player === emptyLevel.entityManager.player)
    }

    // MARK: player
    func testPlayer() {
        //Arrange
        viewModel.cardName.value = "jump"
        currentLevel.level.waitForValueUpdate()

        //Act
        let result = viewModel.player

        //Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(emptyLevel.entityManager.player === result)
    }

    func testPlayer_NoLevel() {
        //Act
        let result = viewModel.player

        //Assert
        XCTAssertNil(result)
    }

    // MARK: reset
    func testReset_Item() {
        //Arrange
        viewModel.cardName.value = "pickup"
        currentLevel.level.waitForValueUpdate()

        //Act
        viewModel.reset()

        //Assert
        XCTAssertTrue(currentLevel.level.value === itemLevel)
        wait(for: [repository.itemResetExpectation], timeout: 0.1)
        XCTAssertTrue(viewModel.player === itemLevel.entityManager.player)
    }

    func testReset_Empty() {
        //Arrange
        viewModel.cardName.value = "right"
        currentLevel.level.waitForValueUpdate()

        //Act
        viewModel.reset()

        //Assert
        XCTAssertTrue(currentLevel.level.value === emptyLevel)
        wait(for: [repository.emptyResetExpectation], timeout: 0.1)
        XCTAssertTrue(viewModel.player === emptyLevel.entityManager.player)
    }

    func testReset_NoLevel() {
        //Arrange
        repository.emptyResetExpectation.isInverted = true
        repository.itemResetExpectation.isInverted = true

        //Act
        viewModel.reset()

        //Assert
        XCTAssertNil(currentLevel.level.value)
        wait(for: [repository.emptyResetExpectation], timeout: 0.1)
        wait(for: [repository.itemResetExpectation], timeout: 0.1)
        XCTAssertNil(viewModel.player)
    }
}

private class LevelMock: LevelProtocol {

    let name = ""
    let levelNumber: Int
    let levelType = ""
    let unlocked = true
    var unlocks: Int?
    var infoLabel: String?
    let entityManager = EntityManager()
    weak var delegate: LevelDelegate?

    init(id: Int) {
        levelNumber = id
    }

    func update(currentTime: TimeInterval) {
        //Ignored
    }

    func isComplete() -> Bool {
        return false
    }
}

private class LevelRepositoryMock: LevelRepository {

    private let emptyLevel: LevelProtocol
    private let itemLevel: LevelProtocol

    var emptyResetExpectation = XCTestExpectation(description: "Level reset called for empty level")
    var itemResetExpectation = XCTestExpectation(description: "Level reset called for item level")

    init(emptyLevel: LevelProtocol, itemLevel: LevelProtocol) {
        self.emptyLevel = emptyLevel
        self.itemLevel = itemLevel
    }

    func loadEmptyLevel(completion: @escaping (LevelProtocol) -> Void) {
        completion(emptyLevel)
    }

    func loadItemLevel(completion: @escaping (LevelProtocol) -> Void) {
        completion(itemLevel)
    }

    func loadLevel(withNumber id: Int, completion: @escaping (LevelProtocol?, LevelLoadingError?) -> Void) {
        if id == emptyLevel.levelNumber {
            emptyResetExpectation.fulfill()
            completion(emptyLevel, nil)
        } else if id == itemLevel.levelNumber {
            itemResetExpectation.fulfill()
            completion(itemLevel, nil)
        } else {
            XCTFail("Unknown level id: \(id)")
        }
    }

    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?) {
        //Ignored
    }

    func loadPreviews(forLevels levelIds: [Int], completion: @escaping ([LevelInfoProtocol]?, LevelLoadingError?) -> Void) {
        //Ignored
    }
}
