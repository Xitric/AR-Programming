//
//  ExampleProgramViewModel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Level

class ExampleProgramViewModel: ExampleProgramViewModeling {
    
    private let levelRepository: LevelRepository
    private var cardObserver: Observer!
    private lazy var _level = ObservableProperty<LevelProtocol>(levelRepository.emptyLevel)
    
    let cardName = ObservableProperty<String?>()
    var level: ImmutableObservableProperty<LevelProtocol> {
        return _level
    }
    
    init(levelRepository: LevelRepository) {
        self.levelRepository = levelRepository
        cardObserver = cardName.observeFuture { [weak self] card in
            guard let card = card,
                let self = self else { return }
            
            if (card == "pickup" || card == "drop") {
                self._level.value = self.levelRepository.levelWithItem
            } else {
                self._level.value = self.levelRepository.emptyLevel
            }
        }
    }
    
    deinit {
        cardObserver.release()
    }
}

protocol ExampleProgramViewModeling {
    var cardName: ObservableProperty<String?> { get }
    var level: ImmutableObservableProperty<LevelProtocol> { get }
}
