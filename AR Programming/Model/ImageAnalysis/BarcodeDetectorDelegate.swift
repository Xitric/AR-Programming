//
//  QRDetectorDelegate.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol BarcodeDetectorDelegate: class {
    func barcodeDetector(_ detector: BarcodeDetector, found graph: ObservationGraph)
}
