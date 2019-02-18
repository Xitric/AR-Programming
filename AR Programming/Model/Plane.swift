//
//  Plane.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

struct Plane: Equatable, Hashable {
    
    let anchor: ARAnchor
    let root: SCNNode
    var groundNode: SCNNode? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromParentNode()
            }
            
            if let groundNode = groundNode {
                root.addChildNode(groundNode)
            }
        }
    }
    
    var center : SCNVector3 {
        get {
            let localCenter = SCNVector4(0, 0, 0, 1)
            let worldCenter = anchor.transform * simd_float4(localCenter)
            return SCNVector3(worldCenter.x, worldCenter.y, worldCenter.z)
        }
    }

    init(anchor: ARAnchor) {
        self.anchor = anchor
        self.root = SCNNode()
    }
    
    public func project(point: SCNVector3) -> Vector2 {
        let inverse = simd_inverse(anchor.transform)
        let localPoint = inverse * simd_float4(point.x, point.y, point.z, 1)
        let projectedPoint = SCNVector3(localPoint.x, 0, localPoint.z)
        return Vector2(x: projectedPoint.x, y: projectedPoint.z)
    }
    
    // TODO: Is getting removed anyway
    static func == (lhs: Plane, rhs: Plane) -> Bool {
        return false
    }
}
