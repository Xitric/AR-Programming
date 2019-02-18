//
//  simd_float4x4+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 18/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

extension simd_float4x4 {
    
    var xAxis: simd_float3 {
        get {
            return simd_float3(x: columns.0.x,
                               y: columns.0.y,
                               z: columns.0.z)
        }
        set {
            columns.0.x = newValue.x
            columns.0.y = newValue.y
            columns.0.z = newValue.z
        }
    }
    var yAxis: simd_float3 {
        get {
            return simd_float3(x: columns.1.x,
                               y: columns.1.y,
                               z: columns.1.z)
        }
        set {
            columns.1.x = newValue.x
            columns.1.y = newValue.y
            columns.1.z = newValue.z
        }
    }
    var zAxis: simd_float3 {
        get {
            return simd_float3(x: columns.2.x,
                               y: columns.2.y,
                               z: columns.2.z)
        }
        set {
            columns.2.x = newValue.x
            columns.2.y = newValue.y
            columns.2.z = newValue.z
        }
    }
    var translation: simd_float3 {
        get {
            return simd_float3(x: columns.3.x,
                               y: columns.3.y,
                               z: columns.3.z)
        }
        set {
            columns.3.x = newValue.x
            columns.3.y = newValue.y
            columns.3.z = newValue.z
        }
    }
}
