//
//  ObservationNode.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd
import Vision

struct ObservationNode: Hashable {
    
    private let barcodeObservation: VNBarcodeObservation
    private let widthScale: Double
    private let heightScale: Double
    
    let payload: String
    var uncertainty: Int
    
    var position: simd_double2 {
        return simd_double2(x: Double(barcodeObservation.boundingBox.midX) * widthScale,
                            y: Double(barcodeObservation.boundingBox.midY) * heightScale)
    }
    
    var width: Double {
        return Double(barcodeObservation.boundingBox.width) * widthScale
    }
    
    var height: Double {
        return Double(barcodeObservation.boundingBox.height) * heightScale
    }
    
    var diagonal: Double {
        let top = Double(barcodeObservation.boundingBox.minY) * heightScale
        let bottom = Double(barcodeObservation.boundingBox.maxY) * heightScale
        let left = Double(barcodeObservation.boundingBox.minX) * widthScale
        let right = Double(barcodeObservation.boundingBox.maxX) * widthScale
        
        return simd_distance(simd_double2(left, top), simd_double2(right, bottom))
    }
    
    var hashValue: Int {
        var hasher = Hasher()
        hasher.combine(payload)
        hasher.combine(position.x)
        hasher.combine(position.y)
        hasher.combine(width)
        hasher.combine(height)
        return hasher.finalize()
    }
    
    init?(barcodeObservation: VNBarcodeObservation, widthScale: Double, heightScale: Double) {
        guard let payload = barcodeObservation.payloadStringValue else {
            return nil
        }
        
        self.barcodeObservation = barcodeObservation
        self.widthScale = widthScale
        self.heightScale = heightScale
        self.payload = payload
        self.uncertainty = 0
    }
    
    static func == (lhs: ObservationNode, rhs: ObservationNode) -> Bool {
        return lhs.payload == rhs.payload
            && lhs.position == rhs.position
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }
}
