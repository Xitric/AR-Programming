//
//  QRDetector.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import CoreGraphics
import Vision

class BarcodeDetector {
    
    private var processing = false
    private let analyzerQueue = DispatchQueue(label: "Barcode detector queue")
    
    private var config: BarcodeDetectorConfig
    private var widthScale: Double
    private var heightScale: Double

    init(config: BarcodeDetectorConfig, screenWidth: Double, screenHeight: Double) {
        self.config = config
        widthScale = screenWidth
        heightScale = screenHeight
    }
    
    //Should only be called from the main thread
    func analyze(frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) {
        //Ignore frames if already processing
        if processing {
            return
        }
        processing = true
        
        //Use a serial queue for processing frames only one at a time
        analyzerQueue.async { [unowned self] in
            do {
                defer { self.processing = false }
                try self.detectBarcodes(inFrame: frame, oriented: orientation)
            } catch let error {
                print(error)
            }
        }
    }
    
    private func detectBarcodes(inFrame frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) throws {
        let handler = config.getHandler(for: frame, oriented: orientation)
        let requests = config.getRequests()
        try handler.perform(requests)
        
        var detectionResult = BarcodeDetectionResult(imageWidth: widthScale, imageHeight: heightScale)
        
        for request in requests {
            if let results = request.results as? [VNBarcodeObservation] {
                for result in results {
                    detectionResult.observations[result.uuid] = result
                }
            }
        }
        
        //Since we are on the processing queue, we must return to main for calling the delegate
        DispatchQueue.main.async { [unowned self] in
            self.config.handle(result: detectionResult)
        }
    }
}

protocol BarcodeDetectorConfig {
    func getHandler(for frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) -> VNImageRequestHandler
    func getRequests() -> [VNDetectBarcodesRequest]
    func handle(result: BarcodeDetectionResult)
}
