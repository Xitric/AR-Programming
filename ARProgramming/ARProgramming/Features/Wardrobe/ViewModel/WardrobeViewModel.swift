//
//  WardrobeViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 07/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class WardrobeViewModel: WardrobeViewModeling {

    private let repository: WardrobeRepository
    private let fileNames: [String]
    private let _robotChoice = ObservableProperty<Int>(0)
    private let _skinCount = ObservableProperty<Int>(0)
    private let _currentRobot = ObservableProperty<String?>()

    var robotChoice: ImmutableObservableProperty<Int> {
        return _robotChoice
    }
    var skinCount: ImmutableObservableProperty<Int> {
        return _skinCount
    }
    var currentRobot: ImmutableObservableProperty<String?> {
        return _currentRobot
    }

    init(repository: WardrobeRepository) {
        self.repository = repository
        self.fileNames = (try? repository.getFileNames()) ?? []
        _skinCount.value = fileNames.count

        repository.selectedRobotSkin { [weak self] skin, _ in
            self?._currentRobot.value = skin

            if let skin = skin {
                self?._robotChoice.value = self?.fileNames.firstIndex(of: skin) ?? 0
            } else {
                self?._robotChoice.value = 0
            }
        }
    }

    func next() {
        if _skinCount.value != 0 {
            _robotChoice.value = (_robotChoice.value + 1) % _skinCount.value
            updateRobotChoice()
        }
    }

    func previous() {
        if _skinCount.value != 0 {
            _robotChoice.value = (_robotChoice.value - 1 + _skinCount.value) % _skinCount.value
            updateRobotChoice()
        }
    }

    private func updateRobotChoice() {
        if _robotChoice.value < _skinCount.value && _robotChoice.value >= 0 {
            _currentRobot.value = fileNames[_robotChoice.value]
        } else {
            _currentRobot.value = nil
        }
    }

    func save(completion: @escaping () -> Void) {
        if let skin = _currentRobot.value {
            repository.setRobotSkin(named: skin) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

protocol WardrobeViewModeling {

    var robotChoice: ImmutableObservableProperty<Int> { get }
    var skinCount: ImmutableObservableProperty<Int> { get }
    var currentRobot: ImmutableObservableProperty<String?> { get }

    func next()
    func previous()
    func save(completion: @escaping () -> Void)
}
