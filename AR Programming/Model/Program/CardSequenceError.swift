//
//  CardSequenceError.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

enum CardSequenceError: Error, Equatable {
    case missingStart
    case unknownCode(code: String)
}
