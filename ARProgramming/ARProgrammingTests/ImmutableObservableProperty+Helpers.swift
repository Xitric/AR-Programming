//
//  ImmutableObservableProperty+Helpers.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 05/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import ARProgramming

extension ImmutableObservableProperty {

    func waitForValueUpdate() {
        let expectation = XCTestExpectation(description: "Observable value updated")
        let observer = observeFuture { _ in
            expectation.fulfill()
        }

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        observer.release()

        switch result {
        case .completed:
            return
        default:
            XCTFail("Something went wrong when waiting for property value to be updated")
        }
    }

    func ensureNotUpdated() {
        let expectation = XCTestExpectation(description: "Observable value did not update")
        expectation.isInverted = true
        let observer = observeFuture { _ in
            expectation.fulfill()
        }

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        observer.release()

        switch result {
        case .completed:
            return
        default:
            XCTFail("Something went wrong when ensuring that the property value did not update")
        }
    }
}
