//
//  AnimatableNode.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

//TODO: Reference to article here
class AnimatableNode {
    
    private(set) var model : SCNNode
    
    init(modelSource: String) {
        let scene = SCNScene(named: modelSource)
        model = scene!.rootNode
    }
}
