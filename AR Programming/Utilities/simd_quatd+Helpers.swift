//
//  simd_quatd+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

extension simd_quatd {
    
    init(_ quadF: simd_quatf) {
        self.init(ix: Double(quadF.imag.x), iy: Double(quadF.imag.y), iz: Double(quadF.imag.z), r: Double(quadF.real))
    }
}
