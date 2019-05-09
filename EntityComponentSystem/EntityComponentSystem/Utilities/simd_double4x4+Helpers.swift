//
//  simd_double4x4+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

extension simd_double4x4 {

    var xAxis: simd_double3 {
        return simd_double3(x: columns.0.x,
                            y: columns.0.y,
                            z: columns.0.z)
    }
    var yAxis: simd_double3 {
        return simd_double3(x: columns.1.x,
                            y: columns.1.y,
                            z: columns.1.z)
    }
    var zAxis: simd_double3 {
        return simd_double3(x: columns.2.x,
                            y: columns.2.y,
                            z: columns.2.z)
    }
    var translation: simd_double3 {
        return simd_double3(x: columns.3.x,
                            y: columns.3.y,
                            z: columns.3.z)
    }
    var rotation: simd_quatd {
        return simd_quatd(self)
    }

    init(translation: simd_double3) {
        self.init(rows: [simd_double4(1, 0, 0, translation.x),
                         simd_double4(0, 1, 0, translation.y),
                         simd_double4(0, 0, 1, translation.z),
                         simd_double4(0, 0, 0, 1)])
    }

    init(translation: simd_double3 = simd_double3(0, 0, 0),
         rotation: simd_quatd = simd_quatd(ix: 0, iy: 0, iz: 0, r: 1)) {
        self = simd_double4x4(translation: translation) * simd_double4x4(rotation)
    }
}
