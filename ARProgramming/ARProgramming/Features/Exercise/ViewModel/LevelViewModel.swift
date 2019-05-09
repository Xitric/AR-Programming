//
//  LevelViewModel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit
import EntityComponentSystem
import Level

/// View model for binding level related data such as level completion and info labels.
class LevelViewModel: LevelViewModeling, LevelDelegate {
    
    private let levelContainer: CurrentLevelProtocol
    private let repository: LevelRepository
    private let scoreManager: ScoreProtocol
    private let _complete = ObservableProperty<Bool>(false)
    private let _levelInfo = ObservableProperty<String?>()
    
    //MARK: - Observers
    private var levelObserver: Observer?
    
    //MARK: - State
    var level: ImmutableObservableProperty<LevelProtocol?> {
        return levelContainer.level
    }
    var complete: ImmutableObservableProperty<Bool> {
        return _complete
    }
    var levelInfo: ImmutableObservableProperty<String?> {
        return _levelInfo
    }
    var player: Entity? {
        return levelContainer.level.value?.entityManager.player
    }
    
    //MARK: - Init
    init(level: CurrentLevelProtocol, levelRepository: LevelRepository, scoreManager: ScoreProtocol) {
        self.levelContainer = level
        self.repository = levelRepository
        self.scoreManager = scoreManager
        
        levelObserver = levelContainer.level.observe { [weak self] newLevel in
            newLevel?.delegate = self
            self?._complete.value = newLevel?.isComplete() ?? false
            self?._levelInfo.value = newLevel?.infoLabel
        }
    }
    
    deinit {
        levelObserver?.release()
    }
    
    func reset() {
        if let levelNumber = levelContainer.level.value?.levelNumber {
            repository.loadLevel(withNumber: levelNumber) { [weak self] newLevel, error in
                if let newLevel = newLevel {
                    DispatchQueue.main.async {
                        self?.levelContainer.level.value = newLevel
                        self?.scoreManager.resetScore()
                    }
                }
            }
        }
    }
    
    func scoreUpdated(newScore: Int) {
        scoreManager.incrementCardCount()
    }
    
    //MARK: - LevelDelegate
    func levelCompleted(_ level: LevelProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.scoreManager.computeScore(level: level.levelNumber)
            self?._complete.value = true
        }
    }
    
    func levelInfoChanged(_ level: LevelProtocol, info: String?) {
        DispatchQueue.main.async { [weak self] in
            self?._levelInfo.value = info
        }
    }
}

protocol LevelViewModeling {
    var level: ImmutableObservableProperty<LevelProtocol?> { get }
    var complete: ImmutableObservableProperty<Bool> { get }
    var levelInfo: ImmutableObservableProperty<String?> { get }
    var player: Entity? { get }
    
    /// Reset the current level.
    func reset()
    
    /// Notify this view model that the player's score has changed.
    ///
    /// - Parameter newScore: The new score.
    func scoreUpdated(newScore: Int)
}
