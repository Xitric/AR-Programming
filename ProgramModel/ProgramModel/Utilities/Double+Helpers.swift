//
//  Double+Helpers.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/2/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

extension Double {
    func isEqual(to other: Double, margin: Double) -> Bool {
        return abs(self - other) <= (margin < 0 ? 0 : margin)
    }
}
