//
//  LevelFactory.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol LevelFactory {
    func canReadLevel(ofType levelType: String) -> Bool
    func initLevel(json: Data) throws -> Level
}

enum LevelLoadingError: Error, Equatable {
    case noSuchLevel(levelNumber: Int)
    case unsupportedLevelType(type: String)
    case badFormat()
}
