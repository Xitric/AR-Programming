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
    
    private let levelRepository: LevelRepository
    
    lazy var level = ObservableProperty<LevelProtocol>(levelRepository.emptyLevel)
    
    init(levelRepository: LevelRepository) {
        self.levelRepository = levelRepository
    }
    
    func loadLevel(withNumber levelNumber: Int) {
        if let level = try? levelRepository.loadLevel(withNumber: levelNumber) {
            self.level.value = level
        }
    }
}

protocol LevelSelectViewModeling {
    
    var level: ObservableProperty<LevelProtocol> { get }
    
    func loadLevel(withNumber: Int)
}
