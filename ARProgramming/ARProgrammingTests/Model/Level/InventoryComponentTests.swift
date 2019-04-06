//
//  InventoryComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import ARProgramming

class InventoryComponentTests: XCTestCase {
    
    private var inv: InventoryComponent!
    
    override func setUp() {
        inv = InventoryComponent()
    }
    
    //MARK: add
    func testAdd() {
        //Act & Assert
        inv.add(quantity: 2, ofType: "a")
        XCTAssertEqual(inv.quantities["a"], 2)
        
        inv.add(quantity: 3, ofType: "a")
        XCTAssertEqual(inv.quantities["a"], 5)
        
        inv.add(quantity: 3, ofType: "b")
        XCTAssertEqual(inv.quantities["a"], 5)
        XCTAssertEqual(inv.quantities["b"], 3)
        
        inv.add(quantity: -1, ofType: "b")
        XCTAssertEqual(inv.quantities["a"], 5)
        XCTAssertEqual(inv.quantities["b"], 2)
        
        inv.add(quantity: -3, ofType: "c")
        XCTAssertEqual(inv.quantities["a"], 5)
        XCTAssertEqual(inv.quantities["b"], 2)
        XCTAssertEqual(inv.quantities["c"], -3)
    }
    
    //MARK: reset
    func testReset() {
        //Arrange
        inv.add(quantity: 2, ofType: "a")
        inv.add(quantity: 5, ofType: "b")
        
        //Act
        inv.reset()
        
        //Assert
        XCTAssertNil(inv.quantities["a"])
        XCTAssertNil(inv.quantities["b"])
    }
}
