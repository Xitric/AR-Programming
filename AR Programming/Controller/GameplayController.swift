//
//  GameplayController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol GameplayController {
    func enter(withLevel level: Level?, inEnvironment arController: ARController?)
    func exit(withLevel level: Level?, inEnvironment arController: ARController?)
}
