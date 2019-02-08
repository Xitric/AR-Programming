//
//  ObservationNode.swift
//  VisionCardTest
//
//  Created by user143563 on 2/1/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation
import simd

class ObservationNode: Hashable {
    
    let code: Int
    let position: simd_double2
    var parent: ObservationNode?
    
    var hashValue: Int {
        var hasher = Hasher()
        hasher.combine(code)
        hasher.combine(position.x)
        hasher.combine(position.y)
        return hasher.finalize()
    }
    
    init(code: Int, position: simd_double2) {
        self.code = code
        self.position = position
    }
    
    static func == (lhs: ObservationNode, rhs: ObservationNode) -> Bool {
        return lhs.code == rhs.code
            && lhs.position == rhs.position
    }
}
