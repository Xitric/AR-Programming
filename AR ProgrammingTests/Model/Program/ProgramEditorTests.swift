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
        editor = ProgramEditor()
    }
    
    private func createGraph(withCodes codes: [String]) -> ObservationGraph {
        var observationSet = ObservationSet()
        
        for (index, code) in codes.enumerated() {
            let node = ObservationNode(payload: code, position: simd_double2(Double(index), 0), width: 1, height: 1)
            observationSet.add(node)
        }
        
        return ObservationGraph(observationSet: observationSet)
    }
    
    func testInit() {
        //Assert
        XCTAssertNil(editor.program.start)
    }
    
    private func assertProgramStructure(codes: [String]) {
        var node = editor.program.start
        
        for code in codes {
            XCTAssertNotNil(node)
            XCTAssertEqual(node!.getCard().internalName,
                           try! CardNodeFactory.instance.cardNode(withCode: code).getCard().internalName)
            XCTAssertEqual(node?.successors.count, 1)
            node = node?.successors[0]
        }
        
        XCTAssertNil(node)
    }
}
