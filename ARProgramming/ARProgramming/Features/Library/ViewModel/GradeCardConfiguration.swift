//
//  GradeCardConfiguration.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// Protocol used to define an association between cards and the various grades.
///
/// Pupils at various grades will have varying levels of expertise with programming, and thus need to be challenged with cards of varying difficulties. This filter allows for displaying more complex cards only to certain grades.
protocol GradeCardConfiguration {
    func isIncluded(cardName: String, forGrade grade: Int) -> Bool
}

struct CardConfig: Decodable, GradeCardConfiguration {

    private let includedCards: [[String]]

    init() {
        self = Config.read(configFile: "cardClasses", toType: CardConfig.self)!
    }

    func isIncluded(cardName: String, forGrade grade: Int) -> Bool {
        for i in 0 ..< grade {
            if includedCards[i].contains(cardName) {
                return true
            }
        }

        return false
    }
}
