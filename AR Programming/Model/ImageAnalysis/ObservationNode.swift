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
    
    let payload: String
    let position: simd_double2
    let width: Double
    let height: Double
    var uncertainty: Int
    
    var diagonal: Double {
        return simd_distance(simd_double2(0, 0), simd_double2(width, height))
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
    
    init(payload: String, position: simd_double2, width: Double, height: Double) {
        self.payload = payload
        self.position = position
        self.width = width
        self.height = height
        self.uncertainty = 0
    }
    
    static func == (lhs: ObservationNode, rhs: ObservationNode) -> Bool {
        return lhs.payload == rhs.payload
            && lhs.position == rhs.position
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }
}
