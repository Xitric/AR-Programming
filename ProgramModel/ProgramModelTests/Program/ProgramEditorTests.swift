//
//  ProgramEditorTests.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class ProgramEditorTests: XCTestCase {

    private var editor: ProgramEditor!

    override func setUp() {
        editor = ProgramEditor(factory: CardNodeFactory())
    }

    // MARK: main
    func testMain_Exists() {
        //Arrange
        let program = Program(startNode: FunctionCardNode(functionNumber: 0, isCaller: false))
        editor.save(program)

        //Act
        var main = editor.main

        //Assert
        XCTAssertTrue(main === program)

        //Arrange
        editor.reset()

        //Act
        main = editor.main

        //Assert
        XCTAssertNil(main.start)
    }

    func testMain_Missing() {
        //Act
        let main = editor.main

        //Assert
        XCTAssertNil(main.start)
    }

    // MARK: allPrograms
    func testAllPrograms() {
        //Arrange
        let program1 = Program(startNode: FunctionCardNode(functionNumber: 0, isCaller: false))
        editor.save(program1)
        let program2 = Program(startNode: SimpleActionCardNode(name: "move", action: MoveAction()))
        editor.save(program2)

        //Act
        var result = editor.allPrograms

        //Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains { $0 === program1 })
        XCTAssertTrue(result.contains { $0 === program2 })

        //Arrange
        editor.reset()

        //Act
        result = editor.allPrograms

        //Assert
        XCTAssertEqual(result.count, 0)
    }

    func testAllPrograms_None() {
        //Act
        let result = editor.allPrograms

        //Assert
        XCTAssertEqual(result.count, 0)
    }

    // MARK: save
    func testSave() {
        //Arrange
        let program = Program(startNode: FunctionCardNode(functionNumber: 4, isCaller: false))

        //Act
        editor.save(program)

        //Assert
        XCTAssertTrue(program.state === editor)
    }

    // MARK: barcodeDetectorFoundNodes
    func testBarcodeDetectorFoundNodes() {
        //Arrange
        let start = ObservationNode(payload: "0", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        let move = ObservationNode(payload: "1", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        let observationSet = ObservationSet(nodes: [start, move])
        let delegate = ProgramEditorDelegateMock()
        editor.delegate = delegate

        //Act
        editor.barcodeDetector(found: observationSet)

        //Assert
        XCTAssertEqual(editor.allCards.count, 2)
        XCTAssertTrue(editor.allCards.contains { $0.card.internalName == "function0a" })
        XCTAssertTrue(editor.allCards.contains { $0.card.internalName == "move" })
        XCTAssertNotNil(delegate.lastProgram)
        XCTAssertNotNil(delegate.lastProgram?.start)
        XCTAssertNotNil(delegate.lastProgram?.start?.children[0])
        XCTAssertEqual(delegate.lastProgram?.start?.children[0].children.count, 0)
    }

    func testBarcodeDetectorFoundNodes_InvalidProgram() {
        //Arrange
        let move = ObservationNode(payload: "1", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        let right = ObservationNode(payload: "3", position: simd_double2(5, 0), width: 0.8, height: 0.8)
        let observationSet = ObservationSet(nodes: [move, right])
        let delegate = ProgramEditorDelegateMock()
        editor.delegate = delegate

        //Act
        editor.barcodeDetector(found: observationSet)

        //Assert
        XCTAssertEqual(editor.allCards.count, 2)
        XCTAssertTrue(editor.allCards.contains { $0.card.internalName == "move" })
        XCTAssertTrue(editor.allCards.contains { $0.card.internalName == "right" })
        XCTAssertNotNil(delegate.lastProgram)
        XCTAssertNil(delegate.lastProgram?.start)
    }

    // MARK: getProgram
    func testGetProgram() {
        //Arrange
        let program1 = Program(startNode: FunctionCardNode(functionNumber: 0, isCaller: false))
        editor.save(program1)
        let program2 = Program(startNode: SimpleActionCardNode(name: "move", action: MoveAction()))
        editor.save(program2)

        //Act & Assert
        XCTAssertTrue(editor.getProgram(forCardWithName: "function0a") === program1)
        XCTAssertTrue(editor.getProgram(forCardWithName: "move") === program2)
        XCTAssertNil(editor.getProgram(forCardWithName: "function1a"))
        XCTAssertNil(editor.getProgram(forCardWithName: ""))
        XCTAssertNil(editor.getProgram(forCardWithName: "function0"))
    }
}

private class ProgramEditorDelegateMock: ProgramEditorDelegate {

    var lastProgram: ProgramProtocol?

    func programEditor(_ programEditor: ProgramEditorProtocol, createdNew program: ProgramProtocol) {
        lastProgram = program
    }
}
