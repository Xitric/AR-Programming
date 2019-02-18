//
//  PlayingField.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import SceneKit

struct PlayingField {
    
    var ground: Plane
    var robot: AnimatableNode
    
    init(ground: Plane, robot: AnimatableNode) {
        self.ground = ground
        self.robot = robot
        addNode(robot.model)
    }
    
    func addNode(_ node: SCNNode) {
        ground.root.addChildNode(node)
    }
}
