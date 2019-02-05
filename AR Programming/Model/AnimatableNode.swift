//
//  AnimatableNode.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

class AnimatableNode {
    
    private(set) var model : SCNNode
    
    init(modelSource: String) {
        let scene = SCNScene(named: modelSource)
        model = scene!.rootNode
    }
}
