//
//  RotateActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class RotateActionComponent: ActionComponent {
    
    let rotation: simd_quatd
    
    init(rotation: simd_quatd, duration: TimeInterval) {
        self.rotation = rotation
        super.init(duration: duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
