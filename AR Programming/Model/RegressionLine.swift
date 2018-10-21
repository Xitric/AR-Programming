//
//  RegressionLine.swift
//  AR Programming
//
//  Created by user143563 on 10/21/18.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import CoreGraphics

class RegressionLine {
    
    private(set) var slope: Float!
    private(set) var intercept: Float!
    
    init(points: [CGPoint]) {
        let primaries = points.map{Float($0.x)}
        let secondaries = points.map{Float($0.y)}
        
        let meanPrimary = mean(of: primaries)
        let meanSecondary = mean(of: secondaries)
        
        let sumOfSquaresPrimary = sumOfSquares(withRespectTo: meanPrimary, values: primaries)
        let sumOfAllProducts = sumOfProducts(withRespectTo: meanPrimary, and: meanSecondary, primaries: primaries, secondaries: secondaries)
        
        slope = sumOfAllProducts / sumOfSquaresPrimary
        intercept = meanSecondary - slope * meanPrimary
    }
    
    func mean(of values: [Float]) -> Float {
        if values.count == 0 {
            return 0
        }
        
        var sum = Float(0)
        
        for value in values {
            sum += value
        }
        
        return sum / Float(values.count)
    }
    
    func sumOfSquares(withRespectTo mean: Float, values: [Float]) -> Float {
        var sum = Float(0)
        
        for value in values {
            sum += powf(value - mean, 2)
        }
        
        return sum
    }
    
    func sumOfProducts(withRespectTo primaryMean: Float, and secondaryMean: Float, primaries: [Float], secondaries: [Float]) -> Float {
        var sum = Float(0)
        let count = min(primaries.count, secondaries.count)
        
        for i in 0..<count {
            sum += (primaries[i] - primaryMean) * (secondaries[i] - secondaryMean)
        }
        
        return sum
    }
}
