//
//  CardGraphDeserializerTests.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 07/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class CardGraphDeserializerTests: XCTestCase {

    private var deserializer: CardGraphDeserializerProtocol!

    override func setUp() {
        deserializer = CardGraphDeserializer(factory: CardNodeFactory())
    }

    // MARK: serializeProgram
    func testSerializeProgram() {
        //Arrange
        let program = createProgram(payloads: ["0", "3", "4"])

        //Act
        let result = deserializer.serialize(program)

        //Assert
        XCTAssertNotNil(result)
        let recreatedProgram = try? deserializer.deserialize(from: result!).main
        XCTAssertNotNil(recreatedProgram)
        XCTAssertTrue(areNodesEqual(n1: program.start!, n2: recreatedProgram!.start!))
    }

    // MARK: serializeEditor
    func testSerializeEditor() {
        //Arrange
        let editor = ProgramEditor(factory: CardNodeFactory())
        let expectedMain = createProgram(payloads: ["0", "3", "12"])
        let expectedFunction1 = createProgram(payloads: ["13", "1", "2"])
        editor.save(expectedMain)
        editor.save(expectedFunction1)

        //Act
        let result = deserializer.serialize(editor)

        //Assert
        XCTAssertNotNil(result)
        let recreatedEditor = try? deserializer.deserialize(from: result!)
        XCTAssertNotNil(recreatedEditor)
        XCTAssertEqual(recreatedEditor?.allPrograms.count, 2)
        XCTAssertTrue(recreatedEditor!.allPrograms.contains {
            areNodesEqual(n1: expectedFunction1.start!, n2: $0.start!)
        })
        XCTAssertTrue(recreatedEditor!.allPrograms.contains {
            $0 === recreatedEditor!.main
        })
        XCTAssertTrue(areNodesEqual(n1: expectedMain.start!, n2: recreatedEditor!.main.start!))
    }

    // MARK: deserialize
    func testDeserialize_Simple() {
        //Arrange
        let data = loadSerializedProgram(named: "SerializedProgram")
        let expectedProgram = createProgram(payloads: ["0", "3", "1"])

        //Act
        let result = try? deserializer.deserialize(from: data)

        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.allPrograms.count, 1)
        XCTAssertTrue(result!.allPrograms.contains {
            $0 === result!.main
        })
        XCTAssertTrue(areNodesEqual(n1: expectedProgram.start!, n2: result!.main.start!))
    }

    func testDeserialize_Complex() {
        //Arrange
        let data = loadSerializedProgram(named: "SerializedComplexProgram")
        let expectedMain = createProgram(payloads: ["0", "1", "12"])
        let expectedFunction1 = createProgram(payloads: ["13", "1", "3", "14"])
        let expectedFunction2 = createProgram(payloads: ["15", "4", "3", "1"])

        //Act
        let result = try? deserializer.deserialize(from: data)

        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.allPrograms.count, 3)
        XCTAssertTrue(result!.allPrograms.contains {
            areNodesEqual(n1: expectedFunction1.start!, n2: $0.start!)
        })
        XCTAssertTrue(result!.allPrograms.contains {
            areNodesEqual(n1: expectedFunction2.start!, n2: $0.start!)
        })
        XCTAssertTrue(result!.allPrograms.contains {
            $0 === result!.main
        })
        XCTAssertTrue(areNodesEqual(n1: expectedMain.start!, n2: result!.main.start!))
    }

    func testDeserialize_InvalidProgram() {
        //Arrange
        let data = loadSerializedProgram(named: "CorruptedSerializedProgram1")
        let expectedProgram = createProgram(payloads: ["13", "1", "3", "14"])

        //Act
        let result = try? deserializer.deserialize(from: data)

        //Assert
        XCTAssertNotNil(result)
        XCTAssertNil(result!.main.start)
        XCTAssertEqual(result?.allPrograms.count, 1)
        XCTAssertTrue(result!.allPrograms.contains {
            areNodesEqual(n1: expectedProgram.start!, n2: $0.start!)
        })
        XCTAssertFalse(result!.allPrograms.contains {
            $0 === result!.main
        })
    }

    func testDeserialize_CorruptedFileFormat() {
        //Arrange
        let data = loadSerializedProgram(named: "CorruptedSerializedProgram2")

        //Act
        let result = try? deserializer.deserialize(from: data)

        //Assert
        XCTAssertNil(result)
    }

    // MARK: Helper methods
    private func loadSerializedProgram(named resource: String) -> Data {
        let url = Bundle(for: CardGraphDeserializerTests.self).url(forResource: resource, withExtension: "json")
        if url == nil {
            XCTFail("Unable to find resource: \(resource).json")
        }

        let data = try? Data(contentsOf: url!)
        if data == nil {
            XCTFail("Unable to load resource: \(resource).json")
        }

        return data!
    }

    private func areNodesEqual(n1: CardNodeProtocol, n2: CardNodeProtocol) -> Bool {
        if n1.card.internalName != n2.card.internalName {
            return false
        }

        if n1.children.count != n2.children.count {
            return false
        }

        for i in 0..<n1.children.count {
            if !areNodesEqual(n1: n1.children[i], n2: n2.children[i]) {
                return false
            }
        }

        return true
    }

    private func createProgram(payloads: [String]) -> Program {
        if payloads.isEmpty {
            return Program(startNode: nil)
        }

        let factory = CardNodeFactory()
        let startNode = try! factory.cardNode(withCode: payloads[0])
        startNode.position = simd_double2(0, 0)
        startNode.size = simd_double2(0.8, 0.8)
        var currentNode = startNode

        for i in 1..<payloads.count {
            let nextNode = try! factory.cardNode(withCode: payloads[i])
            nextNode.position = simd_double2(Double(i), 0)
            nextNode.size = simd_double2(0.8, 0.8)
            currentNode.addSuccessor(nextNode)
            currentNode = nextNode
        }

        return Program(startNode: startNode)
    }
}
