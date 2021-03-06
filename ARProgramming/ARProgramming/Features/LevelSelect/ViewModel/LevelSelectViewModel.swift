//
//  LevelSelectViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Level

class LevelSelectViewModel: LevelSelectViewModeling {

    private let levelContainer: CurrentLevelProtocol
    private let levelRepository: LevelRepository

    var level: ObservableProperty<LevelProtocol?> {
        return levelContainer.level
    }

    init(level: CurrentLevelProtocol, levelRepository: LevelRepository) {
        self.levelContainer = level
        self.levelRepository = levelRepository
    }

    func loadLevel(withNumber levelNumber: Int) {
        levelRepository.loadLevel(withNumber: levelNumber) { [weak self] level, _ in
            if let level = level {
                DispatchQueue.main.async {
                    self?.levelContainer.level.value = level
                }
            }
        }
    }
}

protocol LevelSelectViewModeling {

    var level: ObservableProperty<LevelProtocol?> { get }

    func loadLevel(withNumber: Int)
}
