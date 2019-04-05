//
//  GKEntity+HelpersTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import GameplayKit
@testable import EntityComponentSystem

class GKEntity_HelpersTests: XCTestCase {

    private var entity: GKEntity!
    
    override func setUp() {
        entity = GKEntity()
        entity.addComponent(SuperType())
        entity.addComponent(SubTypeA())
        entity.addComponent(SubTypeB())
        entity.addComponent(SubSubType())
    }
    
    private func assertComponent(_ component: GKComponent, isAmongTypes types: GKComponent.Type...) {
        XCTAssertTrue(types.contains {
            type(of: component) === $0
        })
    }
    
    //MARK: componentSubclassOf
    func testComponentSubclassOf_EmptyEntity() {
        //Arrange
        let entity = GKEntity()
        
        //Act
        let result = entity.component(subclassOf: SuperType.self)
        
        //Assert
        XCTAssertNil(result)
    }
    
    func testComponentSubclassOf_ExactMatch() {
        //Act
        let result = entity.component(subclassOf: SubTypeB.self)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(type(of: result!) === SubTypeB.self)
    }
    
    func testComponentSubclassOf_SubtypeMatch() {
        //Arrange
        entity.removeComponent(ofType: SubTypeA.self)
        
        //Act
        let result = entity.component(subclassOf: SubTypeA.self)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertTrue(type(of: result!) === SubSubType.self)
    }
    
    func testComponentSubclassOf_NoMatch() {
        //Arrange
        entity.removeComponent(ofType: SubTypeA.self)
        entity.removeComponent(ofType: SubSubType.self)
        
        //Act
        let result = entity.component(subclassOf: SubTypeA.self)
        
        //Assert
        XCTAssertNil(result)
    }
    
    func testComponentSubclassOf_MultipleMatches() {
        //Act
        let result = entity.component(subclassOf: SuperType.self)
        
        //Assert
        XCTAssertNotNil(result)
        assertComponent(result!, isAmongTypes: SuperType.self, SubTypeA.self, SubTypeB.self, SubSubType.self)
    }
    
    //MARK: componentsSubclassOf
    func testComponentsSubclassOf_EmptyEntity() {
        //Arrange
        let entity = GKEntity()
        
        //Act
        let result = entity.components(subclassOf: SuperType.self)
        
        //Assert
        XCTAssertTrue(result.isEmpty)
    }
    
    func testComponentsSubclassOf_SingleMatch() {
        //Act
        let result = entity.components(subclassOf: SubSubType.self)
        
        //Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(type(of: result[0]) === SubSubType.self)
    }
    
    func testComponentsSubclassOf_NoMatch() {
        //Arrange
        entity.removeComponent(ofType: SubTypeA.self)
        entity.removeComponent(ofType: SubSubType.self)
        
        //Act
        let result = entity.components(subclassOf: SubTypeA.self)
        
        //Assert
        XCTAssertEqual(result.count, 0)
    }
    
    func testComponentsSubclassOf_MultipleMatches() {
        //Act
        let result = entity.components(subclassOf: SubTypeA.self)
        
        //Assert
        XCTAssertEqual(result.count, 2)
        assertComponent(result[0], isAmongTypes: SubTypeA.self, SubSubType.self)
        assertComponent(result[1], isAmongTypes: SubTypeA.self, SubSubType.self)
    }
}

class SuperType: GKComponent {}
class SubTypeA: SuperType {}
class SubTypeB: SuperType {}
class SubSubType: SubTypeA {}
