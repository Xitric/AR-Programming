//
//  ObservationEdge.swift
//  VisionCardTest
//
//  Created by user143563 on 2/2/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation
import simd

struct ObservationEdge {
    
    let predecessor: ObservationNode
    let successor: ObservationNode
    let connectionAngle: Double
    private var vector: simd_double2 {
        return successor.position - predecessor.position
    }
    
    func correctedAngleTo(edge other: ObservationEdge) -> Double {
        let det = simd_determinant(simd_double2x2(columns: (vector, other.vector)))
        let dot = simd_dot(vector, other.vector)
        let uncorrectedAngle = atan2(det, dot)
        return uncorrectedAngle + connectionAngle - other.connectionAngle
    }
}
