//
//  CardGraphDetector.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 09/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Vision

class CardGraphDetector: BarcodeDetectorConfig {
    
    weak var delegate: CardGraphDetectorDelegate?
    
    func getHandler(for frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) -> VNImageRequestHandler {
        return VNImageRequestHandler(cvPixelBuffer: frame, orientation: orientation)
    }
    
    func getRequests() -> [VNDetectBarcodesRequest] {
        let request = VNDetectBarcodesRequest()
        request.usesCPUOnly = true
        request.symbologies = [.Aztec]
        
        return [request]
    }
    
    func handle(result: BarcodeDetectionResult) {
        delegate?.graphDetector(self, found: result.graph)
    }
}

protocol CardGraphDetectorDelegate: class {
    func graphDetector(_ detector: CardGraphDetector, found graph: ObservationGraph)
}