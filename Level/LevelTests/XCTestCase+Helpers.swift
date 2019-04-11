//
//  XCTestCase+Helpers.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//
import XCTest
import simd

extension XCTestCase {
    
    func vectEqual(_ a: simd_double3, _ b: simd_double3, tolerance: Double) -> Bool {
        return abs(a.x - b.x) < tolerance &&
            abs(a.y - b.y) < tolerance &&
            abs(a.z - b.z) < tolerance
    }
    
    func quatEqual(_ a: simd_quatd, _ b: simd_quatd, tolerance: Double) -> Bool {
        return abs(a.imag.x - b.imag.x) < tolerance &&
            abs(a.imag.y - b.imag.y) < tolerance &&
            abs(a.imag.z - b.imag.z) < tolerance &&
            abs(a.real - b.real) < tolerance
    }
}
