//
//  ExampleProgramViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Level
import EntityComponentSystem

class ExampleProgramViewModel: ExampleProgramViewModeling {
    
    private let levelContainer: CurrentLevelProtocol
    private let levelRepository: LevelRepository
    private var cardObserver: Observer?
    
    let cardName = ObservableProperty<String?>()
    var player: Entity? {
        return levelContainer.level.value?.entityManager.player
    }
    
    init(level: CurrentLevelProtocol, levelRepository: LevelRepository) {
        self.levelContainer = level
        self.levelRepository = levelRepository
        
        cardObserver = cardName.observeFuture { [weak self] card in
            guard let card = card,
                let self = self else { return }
            
            if (card == "pickup" || card == "drop") {
                self.levelContainer.level.value = self.levelRepository.levelWithItem
            } else {
                self.levelContainer.level.value = self.levelRepository.emptyLevel
            }
        }
    }
    
    deinit {
        cardObserver?.release()
    }
    
    func reset() {
        if let levelNumber = levelContainer.level.value?.levelNumber {
            if let newLevel = try? levelRepository.loadLevel(withNumber: levelNumber) {
                self.levelContainer.level.value = newLevel
            }
        }
    }
    
    //MARK: - UpdateDelegate
    func update(currentTime: TimeInterval) {
        self.levelContainer.level.value?.update(currentTime: currentTime)
    }
}

protocol ExampleProgramViewModeling: UpdateDelegate {
    var cardName: ObservableProperty<String?> { get }
    var player: Entity? { get }
    
    func reset()
}
