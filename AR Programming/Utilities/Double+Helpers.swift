//
//  Double+Helpers.swift
//  VisionCardTest
//
//  Created by user143563 on 2/2/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation

extension Double {
    func isEqual(to other: Double, margin: Double) -> Bool {
        return abs(self - other) <= (margin < 0 ? 0 : margin)
    }
}
