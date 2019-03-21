//
//  TransformComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class TransformComponent: GKComponent {
    var location: simd_double3
    var rotation: simd_quatd
    var scale: simd_double3
    
    init(location: simd_double3 = simd_double3(0, 0, 0),
         rotation: simd_quatd = simd_quatd(ix: 0, iy: 0, iz: 0, r: 1),
         scale: simd_double3 = simd_double3(1, 1, 1)) {
        self.location = location
        self.rotation = rotation
        self.scale = scale
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
