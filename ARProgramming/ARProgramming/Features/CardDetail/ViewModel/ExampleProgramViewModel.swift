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
    
    private let levelRepository: LevelRepository
    private var cardObserver: Observer!
    
    let cardName = ObservableProperty<String?>()
    lazy var level = ObservableProperty<LevelProtocol>(levelRepository.emptyLevel)
    var player: Entity {
        return level.value.entityManager.player
    }
    
    init(levelRepository: LevelRepository) {
        self.levelRepository = levelRepository
        cardObserver = cardName.observeFuture { [weak self] card in
            guard let card = card,
                let self = self else { return }
            
            if (card == "pickup" || card == "drop") {
                self.level.value = self.levelRepository.levelWithItem
            } else {
                self.level.value = self.levelRepository.emptyLevel
            }
        }
    }
    
    deinit {
        cardObserver.release()
    }
    
    func reset() {
        let levelNumber = level.value.levelNumber
        if let newLevel = try? levelRepository.loadLevel(withNumber: levelNumber) {
            self.level.value = newLevel
        }
    }
    
    //MARK: - UpdateDelegate
    func update(currentTime: TimeInterval) {
        self.level.value.update(currentTime: currentTime)
    }
}

protocol ExampleProgramViewModeling: UpdateDelegate {
    var cardName: ObservableProperty<String?> { get }
    var level: ObservableProperty<LevelProtocol> { get }
    var player: Entity { get }
    
    func reset()
}
