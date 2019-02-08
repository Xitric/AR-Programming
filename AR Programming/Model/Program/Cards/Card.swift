//
//  Card.swift
//  VisionCardTest
//
//  Created by user143563 on 2/1/19.
//  Copyright © 2019 SDU. All rights reserved.
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
