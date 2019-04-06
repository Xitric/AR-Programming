//
//  CardGraphDetector.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 09/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Vision

class CardGraphDetector: BarcodeDetectorState {
    
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
    
    func handle(result: ObservationSet) {
        let graph = ObservationGraph(observationSet: result)
        delegate?.graphDetector(found: graph)
    }
}

protocol CardGraphDetectorDelegate: class {
    func graphDetector(found graph: ObservationGraph)
}
