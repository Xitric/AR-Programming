//
//  ObserverTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import ARProgramming

class ObserverTests: XCTestCase {

    //Used to control and detect when the property is released
    private var strongProperty: ObservableProperty<Int>?
    private weak var weakProperty: ObservableProperty<Int>?
    
    //Used to detect when the observer is released
    private weak var retainedByObserver: RetainedObject?
    
    //Used to detect if the observer is called back correctly
    private var observer: Observer!
    private var mostRecentlyObservedValue: Int?
    private var callbackCount = 0
    
    override func setUp() {
        strongProperty = ObservableProperty<Int>(5)
        weakProperty = strongProperty
        
        let retained = RetainedObject()
        retainedByObserver = retained
        
        observer = strongProperty?.observe { [weak self, retainedByObserver] newValue in
            self?.mostRecentlyObservedValue = newValue
            self?.callbackCount += 1
            _ = retainedByObserver
        }
    }

    //MARK: release
    func testRelease_NoMoreCallbacks() {
        //Act
        observer.release()
        
        //Assert
        XCTAssertNotNil(strongProperty)
        strongProperty?.value = 7
        XCTAssertEqual(mostRecentlyObservedValue, 5)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func testRelease_ObserverDeallocated() {
        //Arrange
        XCTAssertNotNil(retainedByObserver)
        
        //Act
        observer.release()
        
        //Assert
        XCTAssertNil(retainedByObserver)
    }
    
    func testRelease_PropertyDeallocated() {
        //Arrange
        strongProperty = nil
        //Ensure that the property does not self-retain when it has observers
        XCTAssertNil(weakProperty)
        
        //Act & Assert
        //This just has to happen with no errors (silently)
        XCTAssertNoThrow(observer.release())
    }
    
    func testRelease_AlreadyReleased() {
        //Arrange
        observer.release()
        
        //Act & Assert
        //This just has to happen with no errors (silently)
        XCTAssertNoThrow(observer.release())
        strongProperty?.value = 7
        XCTAssertEqual(mostRecentlyObservedValue, 5)
        XCTAssertEqual(callbackCount, 1)
    }
    
    //MARK: Retain cycles
    func testDeallocateProperty_ObserverDeallocated() {
        //Arrange
        XCTAssertNotNil(weakProperty)
        XCTAssertNotNil(retainedByObserver)
        
        //Act
        strongProperty = nil
        
        //Assert
        XCTAssertNil(weakProperty)
        XCTAssertNil(retainedByObserver) //The observer was also deallocated
    }
}

private class RetainedObject {}
