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
    
    weak var delegate: BarcodeDetectorDelegate?
    
    private var processing = false
    private let analyzerQueue = DispatchQueue(label: "Barcode detector queue")
//    private var observations = [UUID: VNBarcodeObservation]()
    
    private var widthScale: Double
    private var heightScale: Double

    init(screenWidth: Double, screenHeight: Double) {
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
        let handler = VNImageRequestHandler(cvPixelBuffer: frame, orientation: orientation)
        let request = VNDetectBarcodesRequest()
        request.usesCPUOnly = true
        request.symbologies = [.Aztec]
        
        try handler.perform([request])
        
        var detectionResult = BarcodeDetectionResult(imageWidth: widthScale, imageHeight: heightScale)
        
        if let results = request.results as? [VNBarcodeObservation] {
            for result in results {
                detectionResult.observations[result.uuid] = result
            }
        }
        
        //Since we are on the processing queue, we must return to main for calling the delegate
        DispatchQueue.main.async { [unowned self] in
            self.delegate?.barcodeDetector(self, found: detectionResult.graph)
        }
    }
    
//    private func trackBarcodes(inFrame frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) throws {
//        let handler = VNSequenceRequestHandler()
//        var requests = [VNRequest]()
//
//        for observation in observations {
//            let request = VNTrackObjectRequest(detectedObjectObservation: observation.value)
//            request.trackingLevel = .accurate
//            requests.append(request)
//        }
//
//        try handler.perform(requests, on: frame, orientation: orientation)
//
//        for request in requests {
//            if let results = request.results as? [VNBarcodeObservation] {
//                guard let result = results.first else {
//                    continue
//                }
//
//                observations[result.uuid] = result
//            }
//        }
//
//        //Since we are on the processing queue, we must return to main for calling the delegate
//        let resultingGraph = graph
//        DispatchQueue.main.async { [unowned self] in
//            self.delegate?.qrDetector(self, found: resultingGraph)
//        }
//    }
}
