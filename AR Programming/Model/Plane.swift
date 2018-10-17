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

    var planeAnchor: ARPlaneAnchor
    var planeNode: SCNNode
    var planeGeometry: SCNPlane

    init(anchor: ARPlaneAnchor){
        self.planeAnchor = anchor
        planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0,  planeAnchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2
    }
}
