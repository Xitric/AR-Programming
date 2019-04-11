//
//  LevelRepository.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public protocol LevelRepository {
    var emptylevel: LevelProtocol { get }
    
    func loadLevel(byName name: String) throws -> LevelProtocol
    func loadAllLevels() throws -> [LevelProtocol]
    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?)
}
