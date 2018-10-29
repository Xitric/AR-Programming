//
//  Plane.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class Plane: AnchoredNode {
    
    var center : SCNVector3 {
        get {
            let localCenter: SCNVector4
            
            if let geometry = node.geometry as? SCNPlane {
                localCenter = SCNVector4(geometry.width / 2, 0, geometry.height / 2, 1)
            } else {
                localCenter = SCNVector4(0, 0, 0, 1)
            }

            let worldCenter = anchor.transform * simd_float4(localCenter)
            return SCNVector3(worldCenter.x, worldCenter.y, worldCenter.z)
        }
    }

    init(width: CGFloat, height: CGFloat, anchor: ARAnchor) {
        let planeGeometry = SCNPlane(width: width, height: height)
        super.init(anchor: anchor, node: SCNNode(geometry: planeGeometry))
        
        node.eulerAngles.x = -.pi / 2
        node.opacity = 0.5
    }
    
    public func project(point: SCNVector3) -> Vector2 {
        let inverse = simd_inverse(anchor.transform)
        let localPoint = inverse * simd_float4(point.x, point.y, point.z, 1)
        let projectedPoint = SCNVector3(localPoint.x, 0, localPoint.z)
        return Vector2(x: projectedPoint.x, y: projectedPoint.z)
    }
}
