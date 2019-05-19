//
//  AddRemoveDelegateMock.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest

class AddRemoveDelegateMock<T> where T: Equatable {

    private var expectedElement: T?

    var addExpectation: XCTestExpectation!
    var removeExpectation: XCTestExpectation!

    func expect(_ element: T) {
        expectedElement = element
        addExpectation = XCTestExpectation(description: "Element added")
        removeExpectation = XCTestExpectation(description: "Element removed")
    }

    func notify(added element: T) {
        if let expectedElement = expectedElement {
            if expectedElement == element {
                addExpectation.fulfill()
            }
        }
    }

    func notify(removed element: T) {
        if let expectedElement = expectedElement {
            if expectedElement == element {
                removeExpectation.fulfill()
            }
        }
    }
}
