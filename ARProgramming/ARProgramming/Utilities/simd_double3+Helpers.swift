//
//  simd_double3+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

extension simd_double3 {
    
    init(_ floatSimd3: simd_float3) {
        self.init(Double(floatSimd3.x), Double(floatSimd3.y), Double(floatSimd3.z))
    }
}
