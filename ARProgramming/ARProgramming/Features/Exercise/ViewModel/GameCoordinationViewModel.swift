//
//  GameCoordinationViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 28/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Level

class GameCoordinationViewModel: GameCoordinationViewModeling {
    
    private let levelConfig: GradeLevelConfiguration
    private var level: ObservableProperty<LevelProtocol>?
    
    var isFirstLevel: Bool {
        if let firstLevel = levelConfig.levels(forGrade: 1).first {
            return level?.value.levelNumber == firstLevel
        }
        
        return false
    }
    
    init(levelConfig: GradeLevelConfiguration) {
        self.levelConfig = levelConfig
    }
    
    func setLevel(level: ObservableProperty<LevelProtocol>) {
        self.level = level
    }
}

protocol GameCoordinationViewModeling {
    
    var isFirstLevel: Bool { get }
    
    /// Since the concrete level is not available when this view model is constructed, it is the responsibility of the client to finalize its initialization by setting the level property.
    ///
    /// - Parameter level: The currently active level.
    func setLevel(level: ObservableProperty<LevelProtocol>)
}
