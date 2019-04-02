//
//  BasicCard.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

struct BasicCard: Card {
    let internalName: String
    let supportsParameter: Bool
    let requiresParameter: Bool
    let connectionAngles: [Double]
}
