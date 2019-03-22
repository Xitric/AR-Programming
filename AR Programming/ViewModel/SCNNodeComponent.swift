//
//  SCNNodeComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class SCNNodeComponent: TransformComponent {
    
    let node: SCNNode
    override var location: simd_double3 {
        get {
            let floatPosition = node.simdPosition
            return simd_double3(x: Double(floatPosition.x),
                                y: Double(floatPosition.y),
                                z: Double(floatPosition.z))
        }
        set {
            node.simdPosition = simd_float3(x: Float(newValue.x),
                                            y: Float(newValue.y),
                                            z: Float(newValue.z))
        }
    }
    override var rotation: simd_quatd {
        get {
            let floatOrientation = node.simdOrientation
            return simd_quatd(ix: Double(floatOrientation.imag.x),
                              iy: Double(floatOrientation.imag.y),
                              iz: Double(floatOrientation.imag.z),
                              r: Double(floatOrientation.real))
        }
        set {
            node.simdOrientation = simd_quatf(ix: Float(newValue.imag.x),
                                              iy: Float(newValue.imag.y),
                                              iz: Float(newValue.imag.z),
                                              r: Float(newValue.real))
        }
    }
    
    init(node: SCNNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
