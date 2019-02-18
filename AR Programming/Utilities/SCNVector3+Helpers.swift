//
//  SCNVector3+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 18/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    
    init(_ simdVector: simd_float3) {
        self.init(simdVector.x, simdVector.y, simdVector.z)
    }
}
