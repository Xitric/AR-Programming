//
//  GameplayController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol GameplayController {
    
    /// Called when the user navigates back to this controller from another controller, or when a new level is selected and a new gameplay session should be created.
    ///
    /// - Parameters:
    ///   - levelViewModel: The view model of the currently active level.
    ///   - arController: The handler for integrating with the ARKit callbacks.
    /// - Tag: GameplayController.enter
    func enter(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?)
    
    /// Called when the user navigates away from this controller. The provided LevelViewModel and ARController wil be the same as those passed in [enter()](x-source-tag://GameplayController.start).
    ///
    /// - Parameters:
    ///   - levelViewModel: The view model of the currently active level.
    ///   - arController: The handler for integrating with the ARKit callbacks.
    /// - Tag: GameplayController.exit
    func exit(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?)
}
