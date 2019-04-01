//
//  GameState.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// This class is used to package the various objects that need to be shared between all the controllers that make up the game view.
///
/// The logic for surface detection, displaying the level, scanning the card sequence, and showing card details has been divided among various controllers. As such, they have a need to share state with each other. By passing around an instance of this class, they can share this information through dependency injection.
/// - Tag: GameState
class GameState {
    
    var levelViewModel: LevelViewModel
    let arController: ARController
    let programEditor: ProgramEditor
    
    
    /// Constructs a new GameState instance.
    ///
    /// - Parameters:
    ///   - levelViewModel: The view model of the currently active level.
    ///   - arController: The handler for integrating with the ARKit callbacks.
    ///   - programEditor: The model for analyzing images and constructing program sequences.
    init(levelViewModel: LevelViewModel, arController: ARController, programEditor: ProgramEditor) {
        self.levelViewModel = levelViewModel
        self.arController = arController
        self.programEditor = programEditor
    }
}
