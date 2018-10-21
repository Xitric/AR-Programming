//
//  RegressionLineTests.swift
//  AR ProgrammingTests
//
//  Created by user143563 on 10/21/18.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import AR_Programming

class RegressionLineTests: XCTestCase {

    private static var accuracy = Float(0.0001)
    private var regression: RegressionLine!
    private var sampleX: [Float]!
    private var sampleY: [Float]!
    
    override func setUp() {
        regression = RegressionLine(points: [])
        sampleX = [-2, 0, 2, 3, 8, 9, 7, 5, 11]
        sampleY = [11, 9, 7, 6, 2, 3, 3, 2, -1]
    }

    override func tearDown() {
        
    }

    func testMean() {
        let mean = regression.mean(of: sampleX)
        
        XCTAssertEqual(mean, 4.7778, accuracy: RegressionLineTests.accuracy)
    }
    
    func testMeanEmptyInput() {
        let mean = regression.mean(of: [])
        
        XCTAssertEqual(mean, 0)
    }
    
    func testSumOfSquares() {
        let mean = regression.mean(of: sampleX)
        let sum = regression.sumOfSquares(withRespectTo: mean, values: sampleX)
        
        XCTAssertEqual(sum, 151.5556, accuracy: RegressionLineTests.accuracy)
    }
    
    func testSumOfSquaresEmptyInput() {
        let mean = regression.mean(of: sampleX)
        let sum = regression.sumOfSquares(withRespectTo: mean, values: [])
        
        XCTAssertEqual(sum, 0)
    }
    
    func testSumOfProducts() {
        let meanX = regression.mean(of: sampleX)
        let meanY = regression.mean(of: sampleY)
        let sum = regression.sumOfProducts(withRespectTo: meanX, and: meanY, primaries: sampleX, secondaries: sampleY)
        
        XCTAssertEqual(sum, -127.6667, accuracy: RegressionLineTests.accuracy)
    }
    
    func testSumOfProductsEmptyInput() {
        let meanX = regression.mean(of: sampleX)
        let meanY = regression.mean(of: sampleY)
        let sum = regression.sumOfProducts(withRespectTo: meanX, and: meanY, primaries: [], secondaries: [])
        
        XCTAssertEqual(sum, 0)
    }
    
    func testSumOfProductsUnevenInput() {
        let meanX = regression.mean(of: sampleX)
        let meanY = regression.mean(of: sampleY)
        let sum = regression.sumOfProducts(withRespectTo: meanX, and: meanY, primaries: sampleX, secondaries: sampleY + [5])
        
        XCTAssertEqual(sum, -127.6667, accuracy: RegressionLineTests.accuracy)
    }
    
    func testRegressionLine() {
        let points = sampleX.enumerated().map { tuple in
            return CGPoint(x: CGFloat(tuple.element), y: CGFloat(sampleY[tuple.offset]))
        }
        
        regression = RegressionLine(points: points)
        
        XCTAssertEqual(regression.slope, -0.8424, accuracy: RegressionLineTests.accuracy)
        XCTAssertEqual(regression.intercept, 8.6914, accuracy: RegressionLineTests.accuracy)
    }
}
