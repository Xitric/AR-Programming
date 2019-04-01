//
//  CardNodeDetector.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 09/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import Vision

class CardNodeDetector: BarcodeDetectorState {
    
    private static let uncertaintyLimit = 5
    
    private let detectionArea: CGRect
    private var previousResult = [CardNode]()
    private var uncertainty = 0
    
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
    
    func handle(result: ObservationSet) {
        var cardNodes = [CardNode]()
        
        for node in result.nodes {
            if let cardNode = try? CardNodeFactory.instance.cardNode(withCode: node.payload) {
                cardNodes.append(cardNode)
            }
        }
        
        if (cardNodes.count < previousResult.count) {
            uncertainty += 1
            if (uncertainty < CardNodeDetector.uncertaintyLimit) {
                return
            }
        }
        
        previousResult = cardNodes
        uncertainty = 0
        
        delegate?.nodeDetector(self, found: previousResult)
    }
}

protocol CardNodeDetectorDelegate: class {
    func nodeDetector(_ detector: CardNodeDetector, found cardNodes: [CardNode])
}
