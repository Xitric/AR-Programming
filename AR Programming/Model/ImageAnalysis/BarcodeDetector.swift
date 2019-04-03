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
    private let analyzerQueue = DispatchQueue(label: "dk.sdu.ARProgramming.serialBarcodeDetectorQueue")
    private var state: BarcodeDetectorState
    
    private var widthScale: Double!
    private var heightScale: Double!
    private var observationSet = ObservationSet()
    
    init(state: BarcodeDetectorState) {
        self.state = state
    }
    
    //Should only be called from the main thread
    func analyze(frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation, frameWidth: Double, frameHeight: Double) {
        //Ignore frames if already processing
        if processing {
            return
        }
        processing = true
        
        //Use a serial queue for processing frames only one at a time
        analyzerQueue.async { [unowned self] in
            self.widthScale = frameWidth
            self.heightScale = frameHeight
            
            do {
                defer {
                    self.processing = false
                }
                try self.detectBarcodes(inFrame: frame, oriented: orientation)
            } catch let error {
                print(error)
            }
        }
    }
    
    private func detectBarcodes(inFrame frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) throws {
        let handler = state.getHandler(for: frame, oriented: orientation)
        let requests = state.getRequests()
        try handler.perform(requests)
        
        observationSet.markIteration()
        for request in requests {
            if let results = request.results as? [VNBarcodeObservation] {
                for result in results {
                    addNode(forObservation: result)
                }
            }
        }
        
        //Since we are on the processing queue, we must return to main for calling the delegate
        DispatchQueue.main.async { [unowned self] in
            self.state.handle(result: self.observationSet)
        }
    }
    
    private func addNode(forObservation observation: VNBarcodeObservation) {
        guard let payload = observation.payloadStringValue else {
            return
        }
        
        let position = simd_double2(x: Double(observation.boundingBox.midX) * widthScale,
                                    y: Double(observation.boundingBox.midY) * heightScale)
        let width = Double(observation.boundingBox.width) * widthScale
        let height = Double(observation.boundingBox.height) * heightScale
        
        let node = ObservationNode(payload: payload, position: position, width: width, height: height)
        observationSet.add(node)
    }
}

protocol BarcodeDetectorState {
    func getHandler(for frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) -> VNImageRequestHandler
    func getRequests() -> [VNDetectBarcodesRequest]
    func handle(result: ObservationSet)
}
