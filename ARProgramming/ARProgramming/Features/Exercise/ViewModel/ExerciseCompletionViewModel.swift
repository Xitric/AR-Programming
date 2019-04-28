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
    
    private let repository: LevelRepository
    private var level: ObservableProperty<LevelProtocol>?
    private(set) var hasNextLevel = false
    
    init(repository: LevelRepository) {
        self.repository = repository
    }
    
    func setLevel(level: ObservableProperty<LevelProtocol>) {
        self.level = level
        hasNextLevel = level.value.unlocks != nil
    }
    
    func reset() {
        if let levelNumber = level?.value.levelNumber {
            if let newLevel = try? repository.loadLevel(withNumber: levelNumber) {
                level?.value = newLevel
            }
        }
    }
    
    func goToNext() {
        if let nextLevelNumber = level?.value.unlocks {
            if let nextLevel = try? repository.loadLevel(withNumber: nextLevelNumber) {
                level?.value = nextLevel
            }
        }
    }
}

protocol ExerciseCompletionViewModeling {
    
    var hasNextLevel: Bool { get }
    
    /// Since the concrete level is not available when this view model is constructed, it is the responsibility of the client to finalize its initialization by setting the level property.
    ///
    /// - Parameter level: The currently active level.
    func setLevel(level: ObservableProperty<LevelProtocol>)
    
    /// Reset the current level.
    func reset()
    
    /// Load and display the level that follows the currently displayed level.
    func goToNext()
}
