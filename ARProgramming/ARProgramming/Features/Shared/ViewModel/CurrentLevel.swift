//
//  CurrentLevel.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 28/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Level

/// An object to be injected into all view models that require knowledge of the currently active level.
///
/// Information about the current level needs to be shared across many view models in an observable manner. This will allow view models to automatically update their contents and properties whenever another view model changes the level, such as during a level reset.
protocol CurrentLevelProtocol {
    var level: ObservableProperty<LevelProtocol?> { get }
}

class CurrentLevel: CurrentLevelProtocol {
    let level = ObservableProperty<LevelProtocol?>()
}
