//
//  CardNodeFactoryTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/3/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class CardNodeFactoryTests: XCTestCase {

    private var graph: ObservationGraph!
    private var node1: ObservationNode!
    private var node2: ObservationNode!
    private var node3: ObservationNode!
    private var node4: ObservationNode!
    private var node5: ObservationNode!
    private var node6: ObservationNode!
    
    // Layout by card number:
    //
    //     |2|
    // |5|1|3| |7|
    //
    //     |4|
    //
    override func setUp() {
        node1 = ObservationNode(payload: "4", position: simd_double2(1, 0), width: 0.8, height: 0.8)
        node2 = ObservationNode(payload: "1", position: simd_double2(2, 1), width: 0.8, height: 0.8)
        node3 = ObservationNode(payload: "2", position: simd_double2(2, 0), width: 0.8, height: 0.8)
        node4 = ObservationNode(payload: "100", position: simd_double2(2, -2), width: 0.8, height: 0.8)
        node5 = ObservationNode(payload: "0", position: simd_double2(0, 0), width: 0.8, height: 0.8)
        node6 = ObservationNode(payload: "3", position: simd_double2(4, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        observationSet.add(node4)
        observationSet.add(node5)
        observationSet.add(node6)
        
        graph = ObservationGraph(observationSet: observationSet)
    }
    
    private func assert(cardNode: CardNode, matchesObservation observationNode: ObservationNode) {
        XCTAssertEqual(cardNode.card.internalName,
                       try! CardNodeFactory.instance.cardNode(withCode: observationNode.payload).card.internalName)
        XCTAssertEqual(cardNode.position, observationNode.position)
    }

    //MARK: build
    func testBuild_WithStart() {
        //Act
        var result = try? CardNodeFactory.instance.build(from: graph)
        
        //Assert
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node5)
        XCTAssertEqual(result!.successors.count, 1)
        
        result = result!.successors[0]
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node1)
        XCTAssertEqual(result!.successors.count, 1)
        
        result = result!.successors[0]
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node3)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertNil(result!.successors[0])
    }
    
    func testBuild_MissingStart() {
        //Arrange
        var observationSet = ObservationSet()
        observationSet.add(node1)
        observationSet.add(node2)
        observationSet.add(node3)
        
        graph = ObservationGraph(observationSet: observationSet)
        
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.build(from: graph)) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.missingStart)
        }
    }
    
    func testBuild_FromFunction() {
        //Arrange
        let node8 = ObservationNode(payload: "15", position: simd_double2(6, 0), width: 0.8, height: 0.8)
        let node9 = ObservationNode(payload: "1", position: simd_double2(7, 0), width: 0.8, height: 0.8)
        
        var observationSet = ObservationSet()
        observationSet.add(node8)
        observationSet.add(node9)
        
        graph = ObservationGraph(observationSet: observationSet)
        
        //Act
        var result = try? CardNodeFactory.instance.build(from: graph)
        
        //Assert
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node8)
        XCTAssertEqual(result!.successors.count, 1)
        
        result = result!.successors[0]
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node9)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertNil(result!.successors[0])
    }
    
    //MARK: cardNodeFor
    func testCardNodeForObservation_Single() {
        //Act
        let result = try? CardNodeFactory.instance.cardNode(for: node6, withParent: nil, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node6)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertNil(result!.successors[0])
        XCTAssertNil(result!.parent)
    }
    
    func testCardNodeForObservation_Sequence() {
        //Act
        let result: CardNode? = try! CardNodeFactory.instance.cardNode(for: node5, withParent: nil, in: graph)
        
        //Assert
        XCTAssertNotNil(result)
        assert(cardNode: result!, matchesObservation: node5)
        XCTAssertEqual(result!.successors.count, 1)
        XCTAssertNil(result?.parent)
        
        let successorResult: CardNode? = result!.successors[0]
        XCTAssertNotNil(successorResult)
        assert(cardNode: successorResult!, matchesObservation: node1)
        XCTAssertEqual(successorResult!.successors.count, 1)
        XCTAssertTrue(successorResult!.parent! === result!)
    }
    
    func testCardNodeForObservation_UnknownCode() {
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.cardNode(for: node4, withParent: nil, in: graph)) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.unknownCode(code: "100"))
        }
    }
    
    //MARK: cardNodeWithCode
    func testCardNodeWithCode_ValidCode() {
        //Act
        let result = try? CardNodeFactory.instance.cardNode(withCode: "3")
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.card.internalName, "right")
    }
    
    func testCardNodeWithCode_UnknownCode() {
        //Act & Assert
        XCTAssertThrowsError(try CardNodeFactory.instance.cardNode(withCode: "-1")) { error in
            XCTAssertEqual(error as! CardSequenceError, CardSequenceError.unknownCode(code: "-1"))
        }
    }
    
    //MARK: register
    func testRegister_NewNode() {
        //Act
        CardNodeFactory.instance.register(cardNode: CardNode(
            card: BasicCard(internalName: "left",
                            supportsParameter: true,
                            requiresParameter: false,
                            connectionAngles: [0])), withCode: "200")
        CardNodeFactory.instance.register(cardNode: CardNode(
            card: BasicCard(internalName: "jump",
                            supportsParameter: true,
                            requiresParameter: false,
                            connectionAngles: [0])), withCode: "-6")
        
        //Assert
        let leftCard = try? CardNodeFactory.instance.cardNode(withCode: "200")
        XCTAssertNotNil(leftCard)
        XCTAssertEqual(leftCard?.card.internalName, "left")
        
        let jumpCard = try? CardNodeFactory.instance.cardNode(withCode: "-6")
        XCTAssertNotNil(jumpCard)
        XCTAssertEqual(jumpCard?.card.internalName, "jump")
    }
    
    func testRegister_ExistingNode() {
        //Act
        let cardNode = CardNode(
            card: BasicCard(internalName: "left",
                            supportsParameter: true,
                            requiresParameter: false,
                            connectionAngles: [0]))
        CardNodeFactory.instance.register(cardNode: cardNode, withCode: "3")
        
        //Assert
        let result = try? CardNodeFactory.instance.cardNode(withCode: "3")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.card.internalName, cardNode.card.internalName)
    }
}
