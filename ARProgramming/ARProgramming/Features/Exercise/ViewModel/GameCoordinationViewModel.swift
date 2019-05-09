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
    private let levelContainer: CurrentLevelProtocol

    var isFirstLevel: Bool {
        if let firstLevel = levelConfig.levels(forGrade: 1).first {
            return levelContainer.level.value?.levelNumber == firstLevel
        }

        return false
    }

    init(levelConfig: GradeLevelConfiguration, level: CurrentLevelProtocol) {
        self.levelConfig = levelConfig
        self.levelContainer = level
    }
}

protocol GameCoordinationViewModeling {

    var isFirstLevel: Bool { get }
}
