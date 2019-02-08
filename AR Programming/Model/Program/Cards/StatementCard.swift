//
//  StatementCard.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

protocol StatementCard: Card {
    //TODO: Pass state for conditional logic
    func getContinuationIndex() -> Int
}
