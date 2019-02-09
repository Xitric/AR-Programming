//
//  CardNodeDetector.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 09/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Vision

class CardNodeDetector: BarcodeDetectorConfig {
    
    private let detectionArea: CGRect
    
    weak var delegate: CardNodeDetectorDelegate?
    
    init(detectionArea: CGRect) {
        self.detectionArea = detectionArea
    }
    
    func getHandler(for frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) -> VNImageRequestHandler {
        return VNImageRequestHandler(cvPixelBuffer: frame, orientation: orientation)
    }
    
    func getRequests() -> [VNDetectBarcodesRequest] {
        let request = VNDetectBarcodesRequest()
        request.usesCPUOnly = true
        request.symbologies = [.Aztec]
        request.regionOfInterest = detectionArea
        
        return [request]
    }
    
    func handle(result: BarcodeDetectionResult) {
        var cardNodes = [CardNode]()
        
        for observation in result.observationSet.observations {
            if let node = try? CardNodeFactory.instance.node(withId: observation.code) {
                cardNodes.append(node)
            }
        }
        
        delegate?.nodeDetector(self, found: cardNodes)
    }
}

protocol CardNodeDetectorDelegate: class {
    func nodeDetector(_ detector: CardNodeDetector, found cardNodes: [CardNode])
}
