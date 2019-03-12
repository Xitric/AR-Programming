//
//  SCNNode+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

extension SCNNode {
    
    func convertToLocal(axis: SCNVector3) -> SCNVector3 {
        var convertedAxis = axis
        
        if let parent = parent {
            convertedAxis = convertVector(axis, to: parent)
        }
        
        return convertedAxis
    }
}
