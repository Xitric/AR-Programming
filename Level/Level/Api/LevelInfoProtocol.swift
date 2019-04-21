//
//  LevelInfoProtocol.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 19/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public protocol LevelInfoProtocol {
    
    var name: String { get }
    var levelNumber: Int { get }
    var levelType: String { get }
    var unlocked: Bool { get }
}
