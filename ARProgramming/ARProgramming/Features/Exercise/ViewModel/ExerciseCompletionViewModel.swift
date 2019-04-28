//
//  ExerciseCompletionViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 28/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Level

class ExerciseCompletionViewModel: ExerciseCompletionViewModeling {
    
    private let levelContainer: CurrentLevelProtocol
    private let repository: LevelRepository
    let hasNextLevel: Bool
    
    init(level: CurrentLevelProtocol, repository: LevelRepository) {
        self.levelContainer = level
        self.repository = repository
        
        hasNextLevel = levelContainer.level.value?.unlocks != nil
    }
    
    func reset() {
        if let levelNumber = levelContainer.level.value?.levelNumber {
            if let newLevel = try? repository.loadLevel(withNumber: levelNumber) {
                levelContainer.level.value = newLevel
            }
        }
    }
    
    func goToNext() {
        if let nextLevelNumber = levelContainer.level.value?.unlocks {
            if let nextLevel = try? repository.loadLevel(withNumber: nextLevelNumber) {
                levelContainer.level.value = nextLevel
            }
        }
    }
}

protocol ExerciseCompletionViewModeling {
    
    var hasNextLevel: Bool { get }
    
    /// Reset the current level.
    func reset()
    
    /// Load and display the level that follows the currently displayed level.
    func goToNext()
}
