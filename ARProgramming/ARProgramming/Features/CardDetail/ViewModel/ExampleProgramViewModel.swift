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
            if card == "pickup" || card == "drop" {
                self?.levelRepository.loadItemLevel {
                    self?.handleLevelLoaded(level: $0)
                }
            } else {
                self?.levelRepository.loadEmptyLevel {
                    self?.handleLevelLoaded(level: $0)
                }
            }
        }
    }

    deinit {
        cardObserver?.release()
    }

    func reset() {
        if let levelNumber = levelContainer.level.value?.levelNumber {
            levelRepository.loadLevel(withNumber: levelNumber) { [weak self] level, _ in
                if let level = level {
                    self?.handleLevelLoaded(level: level)
                }
            }
        }
    }

    private func handleLevelLoaded(level: LevelProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.levelContainer.level.value = level
        }
    }

    // MARK: - UpdateDelegate
    func update(currentTime: TimeInterval) {
        self.levelContainer.level.value?.update(currentTime: currentTime)
    }
}

protocol ExampleProgramViewModeling: UpdateDelegate {
    var cardName: ObservableProperty<String?> { get }
    var player: Entity? { get }

    func reset()
}
