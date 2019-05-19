//
//  LevelServiceCollection.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 09/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Swinject

public extension Container {
    func addLevel() {
        register(LevelRepository.self) { _ in
            LevelManager(
                context: CoreDataRepository(),
                factories: [
                    EmptyLevelFactory(),
                    QuantityLevelFactory(),
                    CleanUpLevelFactory()
                ]
            )
        }
    }
}
