//
//  Plane.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class Plane {

    var planeNode: SCNNode
    var planeGeometry: SCNPlane
    var anchor: ARAnchor
    
    var center : SCNVector3 {
        get {
//            let localCenter = SCNVector3(planeGeometry.width / 2, 0, planeGeometry.height / 2)
            let localCenter = SCNVector4(0, 0, 0, 1)
            let worldCenter = anchor.transform * simd_float4(localCenter)
//            return planeNode.convertVector(localCenter, from: nil)
            return SCNVector3(worldCenter.x, worldCenter.y, worldCenter.z)
        }
    }

    init(width: CGFloat, height: CGFloat, anchor: ARAnchor) {
        planeGeometry = SCNPlane(width: width, height: height)
        planeNode = SCNNode(geometry: planeGeometry)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.5
        self.anchor = anchor
    }
    
    //Point should be in world coordinates
    public func project(point: SCNVector3) -> CGPoint {
        let inverse = simd_inverse(anchor.transform)
        let localPoint = inverse * simd_float4(point.x, point.y, point.z, 1)
        let convertedPoint = SCNVector3(localPoint.x, localPoint.y, localPoint.z)
        
//        let convertedPoint = planeNode.convertVector(point, to: nil)
        return CGPoint(x: Double(convertedPoint.x), y: Double(convertedPoint.z))
    }
}
