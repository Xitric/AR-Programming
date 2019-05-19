//
//  GradeLevelConfiguration.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 24/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol GradeLevelConfiguration {
    func levels(forGrade grade: Int) -> [Int]
}

struct LevelConfig: Decodable, GradeLevelConfiguration {

    private let levels: [[Int]]

    init() {
        self = Config.read(configFile: "LevelClasses", toType: LevelConfig.self)!
    }

    func levels(forGrade grade: Int) -> [Int] {
        if grade > 0 && grade <= levels.count {
            return levels[grade - 1]
        }

        return []
    }
}
