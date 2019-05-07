//
//  ScoreManagerTests.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 07/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import CoreData
@testable import ARProgramming

class ScoreManagerTests: XCTestCase {

    // cards for max score in level 1 = 2
    private var scoreManager: ScoreProtocol!
    private var expectation1: XCTestExpectation!
    private var expectation2: XCTestExpectation!
    private var expectation3: XCTestExpectation!
    private var level = 1

    override func setUp() {
        self.scoreManager = ScoreManager(context: CoreDataRepository())
        expectation1 = XCTestExpectation(description: "1star")
        expectation1.isInverted = true
        expectation2 = XCTestExpectation(description: "2stars")
        expectation2.isInverted = true
        expectation3 = XCTestExpectation(description: "3stars")
        expectation3.isInverted = true
    }

    func test1StarScore() {
        // Arrange
        deleteScore()
        for _ in 1...10 {
            scoreManager.incrementCardCount()
        }

        // Act
        scoreManager.computeScore(level: level)

        // Assert
        wait(for: [expectation1], timeout: 0.2)
        XCTAssertEqual(scoreManager.getScore(forLevel: level), 1)
    }

    func test2StarsScore() {
        // Arrange
        deleteScore()
        for _ in 1...3 {
            scoreManager.incrementCardCount()
        }
        // Act
        scoreManager.computeScore(level: level)

        // Assert
        wait(for: [expectation2], timeout: 0.2)
        XCTAssertEqual(scoreManager.getScore(forLevel: level), 2)
    }

    func test3StarsScore() {
        // Arrange
        deleteScore()
        for _ in 1...2 {
            scoreManager.incrementCardCount()
        }
        // Act
        scoreManager.computeScore(level: level)

        // Assert
        wait(for: [expectation3], timeout: 0.2)
        XCTAssertEqual(scoreManager.getScore(forLevel: level), 3)
    }

    func testSmallerThanCurrentScore() {
        // Arrange
        scoreManager.computeScore(level: level)

        // Assume
        wait(for: [expectation3], timeout: 0.2)
        XCTAssertEqual(scoreManager.getScore(forLevel: level), 3)

        // Act
        for _ in 1...20 {
            scoreManager.incrementCardCount()
        }
        scoreManager.computeScore(level: level)

        // Assert
        wait(for: [expectation1], timeout: 0.2)
        XCTAssertEqual(scoreManager.getScore(forLevel: level), 3)
    }

    private func deleteScore() {
        let repo = CoreDataRepository()

        //Get current selection
        let request = NSFetchRequest<ScoreEntity>(entityName: "ScoreEntity")
        request.predicate = NSPredicate(format: "levelNumber = %d", level)

        let result = try! repo.persistentContainer.viewContext.fetch(request).first

        if let result = result {
            repo.persistentContainer.viewContext.delete(result)
        }

        repo.saveContext()
    }
}
