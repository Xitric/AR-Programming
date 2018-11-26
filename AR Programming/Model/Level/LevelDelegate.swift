//
//  LevelDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 26/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol LevelDelegate: AnyObject {
    
    func collectibleTaken(_ level: Level, x: Int, y: Int)
    
    func levelCompleted(_ level: Level)
    
    func levelReset(_ level: Level)
}
