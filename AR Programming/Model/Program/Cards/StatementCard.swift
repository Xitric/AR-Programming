//
//  StatementCard.swift
//  VisionCardTest
//
//  Created by user143563 on 2/1/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation
import SceneKit

protocol StatementCard: Card {
    //TODO: Pass state for conditional logic
    func getContinuationIndex() -> Int
}
