//
//  LevelRepository.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public protocol LevelRepository {
    
    /// Loads a level that contains only a programmable robot.
    ///
    /// - Parameter completion: Closure to be called when the level has successfully loaded. This closure will be called from a background thread.
    func loadEmptyLevel(completion: @escaping (LevelProtocol) -> Void)
    
    /// Loads a level that contains a programmable robot and an object to interact with.
    ///
    /// - Parameter completion: Closure to be called when the level has successfully loaded. This closure will be called from a background thread.
    func loadItemLevel(completion: @escaping (LevelProtocol) -> Void)
    
    /// Loads the level with the specified id.
    ///
    /// This operation fails if the id is invalid.
    ///
    /// - Parameters:
    ///   - id: The id of the level to load.
    ///   - completion: Closure to be called with either the result of the loading operation or the error that was thrown. Exactly one of the parameters to the closure will be nil.
    func loadLevel(withNumber id: Int, completion: @escaping (LevelProtocol?, LevelLoadingError?) -> Void)
    
    /// Sets the level with the specified id as either locked or unlocked.
    ///
    /// - Parameters:
    ///   - id: The id of the level to lock or unlock.
    ///   - unlocked: True to make the level unlocked, false otherwise.
    ///   - completion: Closure to be called when the operation has finished.
    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?)
    
    /// Loads a collection of previews for the levels with the specified ids.
    ///
    /// Use this method when you just want metadata about levels but do not actually care about the contents of the levels.
    ///
    /// - Parameters:
    ///   - levelIds: The ids of the levels to load metadata about.
    ///   - completion: Closure to be called with either the result of the loading operation or the error that was thrown. Exactly one of the parameters to the closure will be nil.
    func loadPreviews(forLevels levelIds: [Int], completion: @escaping ([LevelInfoProtocol]?, LevelLoadingError?) -> Void)
}
