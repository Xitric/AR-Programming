//
//  Plane.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import ARKit

class Plane: AnchoredNode {
    
    init(width: CGFloat, height: CGFloat, anchor: ARAnchor) {
        let planeGeometry = SCNPlane(width: width, height: height)
        super.init(anchor: anchor, node: SCNNode(geometry: planeGeometry))
        
        node.eulerAngles.x = -.pi / 2
    }
}
