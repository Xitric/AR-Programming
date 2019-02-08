//
//  QRDetectorDelegate.swift
//  VisionCardTest
//
//  Created by user143563 on 2/1/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation

protocol BarcodeDetectorDelegate: class {
    func barcodeDetector(_ detector: BarcodeDetector, found graph: ObservationGraph)
}
