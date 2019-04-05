//
//  ActionComponentTests.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import EntityComponentSystem
@testable import ProgramModel

class ActionComponentTests: XCTestCase {

    private var component: ActionComponent!
    private var entity: Entity!
    
    override func setUp() {
        component = ActionComponent()
        entity = Entity()
        entity.addComponent(component)
    }

    //MARK: complete
    func testComplete() {
        //Arrange
        let completionHandlerExpectation = expectation(description: "Completion handler called")
        component.onComplete = {
            completionHandlerExpectation.fulfill()
        }
        
        //Act
        component.complete()
        
        //Assert
        wait(for: [completionHandlerExpectation], timeout: 1)
        XCTAssertFalse(entity.components.contains(component))
    }
}
