//
//  CardSequenceError.swift
//  VisionCardTest
//
//  Created by user143563 on 2/1/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation

enum CardSequenceError: Error, Equatable {
    case missingStart
    case unknownCode(code: Int)
}
