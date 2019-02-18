//
//  BarcodeDetectionResult.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Vision

struct BarcodeDetectionResult {
    
    private var imageWidth: Double
    private var imageHeight: Double
    
    var observations: [UUID: VNBarcodeObservation]
    
    init(imageWidth: Double, imageHeight: Double) {
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.observations = [UUID: VNBarcodeObservation]()
    }
    
    var graph: ObservationGraph {
        return ObservationGraph(observationSet: observationSet, with: averageObservationDiagonal)
    }
    
    var isEmpty: Bool {
        return observations.isEmpty
    }
    
    var observationSet: ObservationSet {
        var uniqueObservations = ObservationSet()
        
        for (_, observation) in observations {
            if let codeString = observation.payloadStringValue, let code = Int(codeString) {
                let position = simd_double2(Double(observation.boundingBox.midX) * imageWidth, Double(observation.boundingBox.midY) * imageHeight)
                let observationNode = ObservationNode(code: code, position: position)
                
                uniqueObservations.add(observationNode)
            }
        }
        
        uniqueObservations.uniquify(accordingTo: averageObservationDiagonal)
        return uniqueObservations
    }
    
    private var averageObservationDiagonal: Double {
        guard observations.count > 0 else {
            return 0
        }
        
        var accumulatedDiagonals = 0.0
        
        for (_, observation) in observations {
            accumulatedDiagonals += getDiagonal(of: observation)
        }
        
        return accumulatedDiagonals / Double(observations.count)
    }
    
    private func getDiagonal(of result: VNBarcodeObservation) -> Double {
        let top = Double(result.boundingBox.minY) * imageHeight
        let bottom = Double(result.boundingBox.maxY) * imageHeight
        let left = Double(result.boundingBox.minX) * imageWidth
        let right = Double(result.boundingBox.maxX) * imageWidth
        
        return simd_distance(simd_double2(left, top), simd_double2(right, bottom))
    }
}
