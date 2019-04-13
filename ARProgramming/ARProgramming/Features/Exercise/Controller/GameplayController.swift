//
//  GameplayController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// Protocol to implement on all controllers that need to share an instance of LevelViewModel.
protocol GameplayController: class {
    
    var levelViewModel: LevelViewModel? { get set }
}
