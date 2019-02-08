//
//  QRDetectorTests.swift
//  VisionCardTestTests
//
//  Created by Kasper Schultz Davidsen on 2/2/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
import SceneKit
@testable import AR_Programming

class BarcodeDetectorTests: XCTestCase, BarcodeDetectorDelegate {
    
    private var image: UIImage!
    private var detector: BarcodeDetector!
    
    override func setUp() {
        image = UIImage(named: "realistic")
        detector = BarcodeDetector(screenWidth: Double(UIScreen.main.bounds.width),
                                   screenHeight: Double(UIScreen.main.bounds.height))
    }

    func testPerformanceExample() {
        detector.delegate = self
        print("Begun performance testing. Please wait...")
        
        //self.measure {
        //    detector.analyze(image: image!.cgImage!, oriented: CGImagePropertyOrientation(image!.imageOrientation))
        //}
    }
    
    func barcodeDetector(_ detector: BarcodeDetector, found graph: ObservationGraph) {
        do {
            _ = try CardNodeFactory.instance.build(from: graph)
        } catch CardSequenceError.missingStart {
            XCTFail("Could not find start card")
        } catch CardSequenceError.unknownCode(let code) {
            XCTFail("Found unexpected code: \(code)")
        } catch {
            XCTFail("Unexpected error")
        }
    }
}
