//
//  LevelLoadingError.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 04/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public enum LevelLoadingError: Error, Equatable {
    case noSuchLevel(levelNumber: Int)
    case unsupportedLevelType(type: String)
    case badFormat()
}
