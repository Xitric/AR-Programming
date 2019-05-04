//
//  ObservationGraphCardNodeBuilderTests.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import ProgramModel

class ObservationGraphCardNodeBuilderTests: XCTestCase {

    private var factory: CardNodeFactory!
    private var builder: ObservationGraphCardNodeBuilder!

    override func setUp() {
        factory = CardNodeFactory()
        builder = ObservationGraphCardNodeBuilder()
            .using(factory: factory)
    }

    private func makeNode(payload: String) -> ObservationNode {
        return ObservationNode(payload: payload, position: simd_double2(3, -2), width: 0.8, height: 0.8)
    }

    // MARK: getResult
    func testGetResult_NoSpecifiedNode() {
        //Arrange
        let graph = ObservationGraphStub(startNode: makeNode(payload: "0"))
            .addSuccessor(makeNode(payload: "4"))

        //Act
        let result = try! builder.createFrom(graph: graph)
            .getResult()

        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result.card.internalName, "function0a")
        XCTAssertNil(result.parent)
        XCTAssertEqual(result.successors.count, 1)
        XCTAssertEqual(result.children.count, 1)
        XCTAssertNil(result.parameter)

        let successor = result.successors[0]
        XCTAssertNotNil(successor)
        XCTAssertEqual(successor?.card.internalName, "jump")
        XCTAssertTrue(successor?.parent === result)
        XCTAssertEqual(successor?.successors.count, 1)
        XCTAssertEqual(successor?.children.count, 0)
        XCTAssertNil(successor?.successors[0])
        XCTAssertNil(successor?.parameter)

        XCTAssertTrue(vectEqual(simd_double3(result.position.x, result.position.y, 0),
            simd_double3(3, -2, 0),
            tolerance: 0.000001))
        XCTAssertTrue(vectEqual(simd_double3(result.size.x, result.size.y, 0),
            simd_double3(0.8, 0.8, 0),
            tolerance: 0.000001))
    }

    func testGetResult_NoSuccessors() {
        //Arrange
        let graph = ObservationGraphStub()

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "3"))
            .getResult()

        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result.card.internalName, "right")
        XCTAssertNil(result.parent)
        XCTAssertEqual(result.successors.count, 1)
        XCTAssertEqual(result.children.count, 0)
        XCTAssertNil(result.successors[0])
        XCTAssertNil(result.parameter)
    }

    func testGetResult_GotParameterButNotRequired() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "9")) //Param 2

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .getResult()

        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result.card.internalName, "move")
        XCTAssertNil(result.parent)
        XCTAssertEqual(result.successors.count, 1)
        XCTAssertEqual(result.children.count, 1)
        XCTAssertNil(result.successors[0])
        XCTAssertTrue(result.children[0].card is ParameterCard)
        XCTAssertEqual(result.parameter, 2)
    }

    func testGetResult_MissingParameterButRequired() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "2"))

        //Act & Assert
        XCTAssertThrowsError(try builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "6"))
            .getResult()) { error in
            XCTAssertTrue(error is CardSequenceError)
        }
    }

    func testGetResult_NoStart() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "2"))

        //Act & Assert
        XCTAssertThrowsError(try builder.createFrom(graph: graph)
            .getResult()) { error in
                XCTAssertEqual(error as! CardSequenceError, CardSequenceError.missingStart)
        }
    }

    func testGetResult_UnknownCode() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "1000"))

        //Act & Assert
        XCTAssertThrowsError(try builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .getResult()) { error in
                XCTAssertEqual(error as! CardSequenceError, CardSequenceError.unknownCode(code: "1000"))
        }
    }

    func testGetResult_SingleSuccessor() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "2"))
            .addSuccessor(makeNode(payload: "1"))

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "0"))
            .getResult()

        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result.card.internalName, "function0a")
        XCTAssertNil(result.parent)
        XCTAssertEqual(result.successors.count, 1)
        XCTAssertEqual(result.children.count, 1)
        XCTAssertNil(result.parameter)

        let successor = result.successors[0]
        XCTAssertNotNil(successor)
        XCTAssertEqual(successor?.card.internalName, "left")
        XCTAssertTrue(successor?.parent === result)
        XCTAssertEqual(successor?.successors.count, 1)
        XCTAssertEqual(successor?.children.count, 0)
        XCTAssertNil(successor?.successors[0])
        XCTAssertNil(successor?.parameter)
    }

    func testGetResult_Link() {
        //Arrange
        let graph = ObservationGraphStub(startNode: makeNode(payload: "15")) //Function
            .addSuccessor(makeNode(payload: "6")) //Loop
            .addSuccessor(makeNode(payload: "10")) //Parameter
            .addSuccessor(makeNode(payload: "1")) //Move
            .addSuccessor(nil) //Simulate no parameter for move card (above)
            .addSuccessor(nil) //Simulate no parameter for move card (below)
            .addSuccessor(makeNode(payload: "7")) //Border

        //Act
        let result = try! builder.createFrom(graph: graph)
            .getResult()

        //Assert
        let loop = result.successors[0]
        let border = loop?.successors[0]?.successors[0]

        XCTAssertNotNil(loop)
        XCTAssertEqual(loop?.parameter, 3)

        XCTAssertTrue(border is BorderCardNode)
        XCTAssertTrue((border as? BorderCardNode)?.loopCardNode === loop)
    }

    // MARK: findParameter
    func testFindParameter_NoCard() {
        //Arrange
        let graph = ObservationGraphStub()

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .findParameter()

        //Assert
        XCTAssertNil(result)
    }

    func testFindParameter_NotParameterCard() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "3"))

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .findParameter()

        //Assert
        XCTAssertNil(result)
    }

    func testFindParameter_FoundAbove() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "10")) //Param 3

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .findParameter()

        //Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.card is ParameterCard)
        XCTAssertEqual((result?.card as? ParameterCard)?.parameter, 3)
        XCTAssertEqual(result?.entryAngle, Double.pi/2)
    }

    func testFindParameter_FoundBelow() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(nil) //First successor fails
            .addSuccessor(makeNode(payload: "9")) //Param 2

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .findParameter()

        //Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.card is ParameterCard)
        XCTAssertEqual((result?.card as? ParameterCard)?.parameter, 2)
        XCTAssertEqual(result?.entryAngle, -Double.pi/2)
    }

    func testFindParameter_NoNode() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "9")) //Param 2

        //Act
        let result = try! builder.createFrom(graph: graph)
            .findParameter()

        //Assert
        XCTAssertNil(result)
    }

    // MARK: findSuccessors
    func testFindSuccessors_None() {
        //Arrange
        let graph = ObservationGraphStub()

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .findSuccessors(byAngles: [1.3])

        //Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertNil(result[0])
    }

    func testFindSuccessors_OneAngleFound() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "3"))

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .findSuccessors(byAngles: [0.7])

        //Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertNotNil(result[0])
        XCTAssertEqual(result[0]?.entryAngle, 0.7)
        XCTAssertEqual(result[0]?.card.internalName, "right")
    }

    func testFindSuccessors_TwoAnglesOneMissing() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(nil)
            .addSuccessor(makeNode(payload: "3"))

        //Act
        let result = try! builder.createFrom(graph: graph)
            .using(node: makeNode(payload: "1"))
            .findSuccessors(byAngles: [0.4, -0.4])

        //Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertNil(result[0])

        XCTAssertNotNil(result[1])
        XCTAssertEqual(result[1]?.entryAngle, -0.4)
        XCTAssertEqual(result[1]?.card.internalName, "right")
    }

    func testFindSuccessors_NoNode() {
        //Arrange
        let graph = ObservationGraphStub()
            .addSuccessor(makeNode(payload: "3"))

        //Act
        let result = try! builder.createFrom(graph: graph)
            .findSuccessors(byAngles: [1.2])

        //Assert
        XCTAssertEqual(result.count, 0)
    }
}

class ObservationGraphStub: ObservationGraph {

    private let startNode: ObservationNode?
    private var successorStack = [ObservationNode?]()

    init(startNode: ObservationNode?) {
        self.startNode = startNode
        super.init(observationSet: ObservationSet(nodes: []))
    }

    convenience init() {
        self.init(startNode: nil)
    }

    @discardableResult
    func addSuccessor(_ successor: ObservationNode?) -> ObservationGraphStub {
        successorStack.insert(successor, at: 0)
        return self
    }

    override func firstNode(withPayloadIn payloads: [String]) -> ObservationNode? {
        return startNode
    }

    override func getSuccessor(by angle: Double, to node: ObservationNode) -> ObservationNode? {
        return successorStack.popLast() ?? nil
    }

    override func connect(from parent: ObservationNode, to child: ObservationNode, withAngle correctedAngle: Double) {
        //Ignored, this is irrelevant for the stub
    }
}
