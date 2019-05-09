//
//  LevelInfo.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 19/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

struct LevelInfo: LevelInfoProtocol, Decodable {

    var name: String
    var levelNumber: Int
    var levelType: String
    var unlocked = false

    private enum CodingKeys: String, CodingKey {
        case name
        case levelNumber = "number"
        case levelType = "type"
    }
}
