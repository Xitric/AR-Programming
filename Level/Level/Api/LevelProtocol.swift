//
//  LevelProtocol.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

public protocol LevelProtocol: class {
    var name: String { get }
    var levelNumber: Int { get }
    var levelType: String { get }
    var unlocked: Bool { get }
    var unlocks: Int? { get }
    var infoLabel: String? { get }
    var entityManager: EntityManager { get }
    var delegate: LevelDelegate? { get set }
    
    func update(currentTime: TimeInterval)
    func isComplete() -> Bool
}

public protocol LevelDelegate: class {
    func levelCompleted(_ level: LevelProtocol)
    func levelInfoChanged(_ level: LevelProtocol, info: String?)
}
