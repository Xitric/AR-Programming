//
//  ParameterCard.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 28/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

struct ParameterCard: Card {
    let parameter: Int
    var internalName: String {
        return "param\(parameter)"
    }
    let supportsParameter = false
    let requiresParameter = false
    let connectionAngles = [Double]()
}
