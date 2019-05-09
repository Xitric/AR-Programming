//
//  WardrobeViewModelTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 07/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import ARProgramming

class WardrobeViewModelTests: XCTestCase {

    private var viewModel: WardrobeViewModeling!
    private var repository: WardrobeRepositoryMock!

    override func setUp() {
        repository = WardrobeRepositoryMock()
    }

    // MARK: init
    func testInit() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b", "c", "d"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion("b", nil)
        }

        //Act
        viewModel = WardrobeViewModel(repository: repository)

        //Assert
        XCTAssertEqual(viewModel.skinCount.value, 4)
        XCTAssertEqual(viewModel.currentRobot.value, "b")
        XCTAssertEqual(viewModel.robotChoice.value, 1)
    }

    func testInit_NoFiles() {
        //Arrange
        repository.getFileNamesClosure = {
            return []
        }
        repository.selectedRobotSkinClosure = { completion in
            completion(nil, nil)
        }

        //Act
        viewModel = WardrobeViewModel(repository: repository)

        //Assert
        XCTAssertEqual(viewModel.skinCount.value, 0)
        XCTAssertNil(viewModel.currentRobot.value)
        XCTAssertEqual(viewModel.robotChoice.value, 0)
    }

    func testInit_NoSelection() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion(nil, nil)
        }

        //Act
        viewModel = WardrobeViewModel(repository: repository)

        //Assert
        XCTAssertEqual(viewModel.skinCount.value, 2)
        XCTAssertNil(viewModel.currentRobot.value)
        XCTAssertEqual(viewModel.robotChoice.value, 0)
    }

    // MARK: next
    func testNext() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b", "c"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion("a", nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        viewModel.next()

        //Assert
        XCTAssertEqual(viewModel.robotChoice.value, 1)
        XCTAssertEqual(viewModel.currentRobot.value, "b")
    }

    func testNext_AtEdge() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b", "c"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion("c", nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        viewModel.next()

        //Assert
        XCTAssertEqual(viewModel.robotChoice.value, 0)
        XCTAssertEqual(viewModel.currentRobot.value, "a")
    }

    func testNext_NoFiles() {
        //Arrange
        repository.getFileNamesClosure = {
            return []
        }
        repository.selectedRobotSkinClosure = { completion in
            completion(nil, nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        viewModel.next()

        //Assert
        XCTAssertEqual(viewModel.robotChoice.value, 0)
        XCTAssertNil(viewModel.currentRobot.value)
    }

    // MARK: previous
    func testPrevious() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b", "c"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion("c", nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        viewModel.previous()

        //Assert
        XCTAssertEqual(viewModel.robotChoice.value, 1)
        XCTAssertEqual(viewModel.currentRobot.value, "b")
    }

    func testPrevious_AtEdge() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b", "c"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion("a", nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        viewModel.previous()

        //Assert
        XCTAssertEqual(viewModel.robotChoice.value, 2)
        XCTAssertEqual(viewModel.currentRobot.value, "c")
    }

    func testPrevious_NoFiles() {
        //Arrange
        repository.getFileNamesClosure = {
            return []
        }
        repository.selectedRobotSkinClosure = { completion in
            completion(nil, nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        viewModel.previous()

        //Assert
        XCTAssertEqual(viewModel.robotChoice.value, 0)
        XCTAssertNil(viewModel.currentRobot.value)
    }

    // MARK: save
    func testSave() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion("b", nil)
        }
        let setSkinExpectation = XCTestExpectation(description: "Robot skin set")
        repository.setRobotSkinClosure = { skin, completion in
            if skin == "b" {
                setSkinExpectation.fulfill()
            }
            completion(nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        let saveExpectation = XCTestExpectation(description: "Save callback")
        viewModel.save {
            saveExpectation.fulfill()
        }

        //Assert
        wait(for: [setSkinExpectation, saveExpectation], timeout: 0.1, enforceOrder: true)
    }

    func testSave_NoSelection() {
        //Arrange
        repository.getFileNamesClosure = {
            return []
        }
        repository.selectedRobotSkinClosure = { completion in
            completion(nil, nil)
        }
        let setSkinExpectation = XCTestExpectation(description: "Robot skin was not set")
        setSkinExpectation.isInverted = true
        repository.setRobotSkinClosure = { _, completion in
            setSkinExpectation.fulfill()
            completion(nil)
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        let saveExpectation = XCTestExpectation(description: "Save callback")
        viewModel.save {
            saveExpectation.fulfill()
        }

        //Assert
        wait(for: [setSkinExpectation, saveExpectation], timeout: 0.1, enforceOrder: true)
    }

    func testSave_Error() {
        //Arrange
        repository.getFileNamesClosure = {
            return ["a", "b"]
        }
        repository.selectedRobotSkinClosure = { completion in
            completion("b", nil)
        }
        let setSkinExpectation = XCTestExpectation(description: "Robot skin set")
        repository.setRobotSkinClosure = { _, completion in
            setSkinExpectation.fulfill()
            completion(NSError(domain: "Test", code: 1, userInfo: nil))
        }
        viewModel = WardrobeViewModel(repository: repository)

        //Act
        let saveExpectation = XCTestExpectation(description: "Save callback")
        viewModel.save {
            saveExpectation.fulfill()
        }

        //Assert
        wait(for: [setSkinExpectation, saveExpectation], timeout: 0.1, enforceOrder: true)
    }
}

//A mock of the repository that allows for each test to selectively provide an implementation to each method by providing a matching closure.
private class WardrobeRepositoryMock: WardrobeRepository {

    var getFileNamesClosure: (() throws -> [String])?
    var selectedRobotSkinClosure: (((String?, Error?) -> Void) -> Void)?
    var setRobotSkinClosure: ((String, (Error?) -> Void) -> Void)?

    func getFileNames() throws -> [String] {
        return try getFileNamesClosure?() ?? []
    }

    func selectedRobotSkin(completion: @escaping (String?, Error?) -> Void) {
        selectedRobotSkinClosure?(completion)
    }

    func setRobotSkin(named choice: String, completion: @escaping (Error?) -> Void) {
        setRobotSkinClosure?(choice, completion)
    }
}
