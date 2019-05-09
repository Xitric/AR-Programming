//
//  ObservablePropertyTests.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import ARProgramming

class ObservablePropertyTests: XCTestCase {

    private var property: ObservableProperty<Int>!

    override func setUp() {
        property = ObservableProperty<Int>(5)
    }

    // MARK: init
    func testInit_WithInitial() {
        //Assert
        XCTAssertEqual(property.value, 5)
    }

    func testInit_WithOptional() {
        //Act
        var optionalProperty = ObservableProperty<Int?>()

        //Assert
        XCTAssertNil(optionalProperty.value)

        //Act
        optionalProperty = ObservableProperty<Int?>(-4)

        //Assert
        XCTAssertEqual(optionalProperty.value, -4)
    }

    // MARK: observe
    func testObserve() {
        //Arrange
        var mostRecentlyObservedValue: Int?
        var callbackCount = 0
        let observer: (Int) -> Void = { newValue in
            mostRecentlyObservedValue = newValue
            callbackCount += 1
        }

        //Set up to get initial value
        //Act
        _ = property.observe(withClosure: observer)

        //Assert
        XCTAssertEqual(mostRecentlyObservedValue, 5)
        XCTAssertEqual(callbackCount, 1)

        //Call with new value
        //Act
        property.value = 7

        //Assert
        XCTAssertEqual(mostRecentlyObservedValue, 7)
        XCTAssertEqual(callbackCount, 2)

        //Call with same value again
        //Act
        property.value = 7

        //Assert
        XCTAssertEqual(mostRecentlyObservedValue, 7)
        XCTAssertEqual(callbackCount, 3)
    }

    // MARK: observeFuture
    func testObserveFuture() {
        //Arrange
        var mostRecentlyObservedValue: Int?
        var callbackCount = 0
        let observer: (Int) -> Void = { newValue in
            mostRecentlyObservedValue = newValue
            callbackCount += 1
        }

        //Set up and get no value
        //Act
        _ = property.observeFuture(withClosure: observer)

        //Assert
        XCTAssertNil(mostRecentlyObservedValue)
        XCTAssertEqual(callbackCount, 0)

        //Call with new value
        //Act
        property.value = 7

        //Assert
        XCTAssertEqual(mostRecentlyObservedValue, 7)
        XCTAssertEqual(callbackCount, 1)

        //Call with same value again
        //Act
        property.value = 7

        //Assert
        XCTAssertEqual(mostRecentlyObservedValue, 7)
        XCTAssertEqual(callbackCount, 2)
    }
}
