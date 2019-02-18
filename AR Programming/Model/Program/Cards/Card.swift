//
//  Card.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

protocol Card {
    var name: String { get }
    var internalName: String { get }
    var summary: String { get }
    var description: String { get }
    
    func getAction(for robot: SCNNode) -> SCNAction?
}

extension Card {
    public func convert(axis: SCNVector3, to node: SCNNode) -> SCNVector3 {
        var convertedAxis = axis
        
        if let parent = node.parent {
            convertedAxis = node.convertVector(axis, to: parent)
        }
        
        return convertedAxis
    }
}
