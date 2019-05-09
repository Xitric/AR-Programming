//
//  WardrobeManagerTests.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import CoreData
@testable import ARProgramming

class WardrobeManagerTests: XCTestCase {

    private var wardrobe: WardrobeRepository!
    private var repository: CoreDataRepository!

    override func setUp() {
        repository = CoreDataRepository()
        wardrobe = WardrobeManager(context: repository)
    }

    // MARK: getFileNames
    func testGetFileNames() {
        do {
            //Act
            let fileNames = try wardrobe.getFileNames()

            //Assert
            XCTAssertEqual(fileNames.count, 7)
            XCTAssertTrue(fileNames.contains { $0 == "Robot/blueBot" })
            XCTAssertTrue(fileNames.contains { $0 == "Robot/greenBot" })
            XCTAssertTrue(fileNames.contains { $0 == "Robot/greyBot" })
            XCTAssertTrue(fileNames.contains { $0 == "Robot/orangeBot" })
            XCTAssertTrue(fileNames.contains { $0 == "Robot/redBot" })
            XCTAssertTrue(fileNames.contains { $0 == "Robot/uglyBot" })
            XCTAssertTrue(fileNames.contains { $0 == "Robot/yellowBot" })
        } catch {
            XCTFail("Unable to fetch robot skin file names")
        }
    }

    // MARK: selectedRobotSkin
    func testSelectedRobotSkin() {
        //No selected skin
        //Arrange
        deleteSkinChoice()
        let defaultSkinExpectation = XCTestExpectation(description: "Default skin selected")
        //Physical devices and emulators sort files in different orders
        let defaultSkinRealDevice = "Robot/uglyBot"
        let defaultSkinEmulator = "Robot/blueBot"

        //Act & Assert
        wardrobe.selectedRobotSkin { skin, error in
            if error != nil {
                XCTFail("Error fetching skin choice")
            }

            if skin == defaultSkinRealDevice || skin == defaultSkinEmulator {
                defaultSkinExpectation.fulfill()
            }
        }

        //Assert
        wait(for: [defaultSkinExpectation], timeout: 0.5)

        //A specific skin is selected
        //Arrange
        let greenSkinExpectation = XCTestExpectation(description: "Green skin selected")
        let greenSkin = "Robot/greenBot"
        let setExpectation = XCTestExpectation(description: "Set robot skin")
        wardrobe.setRobotSkin(named: greenSkin) { error in
            if error != nil {
                XCTFail("Error setting robot skin")
            }

            setExpectation.fulfill()
        }
        wait(for: [setExpectation], timeout: 0.5)

        //Act & Assert
        wardrobe.selectedRobotSkin { skin, error in
            if error != nil {
                XCTFail("Error fetching skin choice")
            }

            if skin == greenSkin {
                greenSkinExpectation.fulfill()
            }
        }

        //Assert
        wait(for: [greenSkinExpectation], timeout: 0.5)
    }

    // MARK: setRobotChoice
    func testSetRobotChoice() {
        //Set when there is currently no selection
        //Arrange
        deleteSkinChoice()
        let blueSkin = "Robot/blueBot"
        let blueSkinExpectation = expectation(description: "Blue robot was chosen")

        //Act
        wardrobe.setRobotSkin(named: blueSkin) { error in
            if error == nil {
                blueSkinExpectation.fulfill()
            }
        }

        //Assert
        wait(for: [blueSkinExpectation], timeout: 0.5)
        ensureSkinSelected(skin: blueSkin)

        //Set on top of existing selection
        //Arrange
        let greenSkin = "Robot/greenBot"
        let greenSkinExpectation = expectation(description: "Green robot was chosen")

        //Act
        wardrobe.setRobotSkin(named: greenSkin) { error in
            if error == nil {
                greenSkinExpectation.fulfill()
            }
        }

        //Assert
        wait(for: [greenSkinExpectation], timeout: 0.5)
        ensureSkinSelected(skin: greenSkin)
    }

    // MARK: Helper methods
    private func deleteSkinChoice() {
        //Get current selection
        let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")
        let result = try! repository.persistentContainer.viewContext.fetch(request).first

        if let result = result {
            repository.persistentContainer.viewContext.delete(result)
        }

        repository.saveContext()
    }

    private func ensureSkinSelected(skin: String) {
        let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")
        let result = try! repository.persistentContainer.viewContext.fetch(request).first

        XCTAssertEqual(result?.choice, skin)
    }
}
