//
//  GameplayController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// Protocol to implement on all controllers that require an instance of [GameState](x-source-tag://GameState) to share information.
protocol GameplayController {
    
    /// Called when the user navigates back to this controller from another controller, or when a new level is selected and a new gameplay session should be created.
    ///
    /// - Parameters:
    ///   - state: The shared state object for all game view controllers.
    /// - Tag: GameplayController.enter
    func enter(withState state: GameState)
    
    /// Called when the user navigates away from this controller. The provided GameState will be the same as the one passed in [enter()](x-source-tag://GameplayController.enter).
    ///
    /// - Parameters:
    ///   - state: The shared state object for all game view controllers.
    /// - Tag: GameplayController.exit
    func exit(withState state: GameState)
}
