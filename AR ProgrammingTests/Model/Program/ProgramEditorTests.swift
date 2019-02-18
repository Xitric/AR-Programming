//
//  ProgramEditorTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 10/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import simd
@testable import AR_Programming

class ProgramEditorTests: XCTestCase {

    private var detector: CardGraphDetector!
    private var editor: ProgramEditor!
    
    override func setUp() {
        detector = CardGraphDetector()
        editor = ProgramEditor(screenWidth: 500, screenHeight: 500)
    }
    
    private func createGraph(withCodes codes: [Int]) -> ObservationGraph {
        var observationSet = ObservationSet()
        
        for (index, code) in codes.enumerated() {
            let node = ObservationNode(code: code, position: simd_double2(Double(index), 0))
            observationSet.add(node)
        }
        
        observationSet.uniquify(accordingTo: 1)
        return ObservationGraph(observationSet: observationSet, with: 1)
    }
    
    func testInit() {
        //Assert
        XCTAssertNil(editor.program.start)
    }
    
    private func assertProgramStructure(codes: [Int]) {
        var node = editor.program.start
        
        for code in codes {
            XCTAssertNotNil(node)
            XCTAssertEqual(node!.getCard().internalName,
                           try! CardNodeFactory.instance.node(withId: code).getCard().internalName)
            XCTAssertEqual(node?.successors.count, 1)
            node = node?.successors[0]
        }
        
        XCTAssertNil(node)
    }
    
    func testGraphDetector_FirstFrame() {
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0, 3]))
        
        //Assert
        assertProgramStructure(codes: [0, 3])
    }
    
    func testGraphDetector_WithUncertainty() {
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0, 3]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        
        //Assert
        assertProgramStructure(codes: [0, 3])
        
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0, 3]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        
        //Assert
        assertProgramStructure(codes: [0, 3])
    }
    
    func testGraphDetector_LostCards() {
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0, 3]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        
        //Assert
        assertProgramStructure(codes: [0, 3])
        
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        
        //Assert
        assertProgramStructure(codes: [0])
    }
    
    func testGraphDetector_FoundCards() {
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0, 3]))
        
        //Assert
        assertProgramStructure(codes: [0, 3])
        
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0, 3, 4]))
        
        //Assert
        assertProgramStructure(codes: [0, 3, 4])
        
        //Act
        editor.graphDetector(detector, found: createGraph(withCodes: [0]))
        
        //Assert
        assertProgramStructure(codes: [0, 3, 4])
    }
}
