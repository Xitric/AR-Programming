//
//  LevelProtocol.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol LevelProtocol {
    func update(_ delta: TimeInterval)
    func isComplete() -> Bool
    func getScore() -> Int
    func reset()
}
