//
//  LevelRepository.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public protocol LevelRepository {
    var emptyLevel: LevelProtocol { get }
    var levelWithItem: LevelProtocol { get }
    
    func loadLevel(withNumber id: Int) throws -> LevelProtocol
    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?)
    func loadPreviews(forLevels levelIds: [Int]) throws -> [LevelInfoProtocol]
}
