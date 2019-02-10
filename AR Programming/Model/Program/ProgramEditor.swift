//
//  ProgramEditor.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class ProgramEditor: CardGraphDetectorDelegate {
    
    private static let programUncertaintyLimit = 5
    
    private var currentProgram: Program?
    private var programUncertainty = 0
    private let detector: BarcodeDetector
    
    weak var delegate: ProgramEditorDelegate?
    
    var program: Program {
        get {
            return currentProgram == nil ? Program(startNode: nil) : currentProgram!
        }
    }
    
    init(screenWidth: Double, screenHeight: Double) {
        let config = CardGraphDetector()
        detector = BarcodeDetector(config: config, screenWidth: screenWidth, screenHeight: screenHeight)
        config.delegate = self
    }
    
    //Should only be called from the main thread
    func newFrame(_ frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation) {
        detector.analyze(frame: frame, oriented: orientation)
    }
    
    func reset() {
        currentProgram = nil
    }
    
    func graphDetector(_ detector: CardGraphDetector, found graph: ObservationGraph) {
        do {
            let start = try CardNodeFactory.instance.build(from: graph)
            let newProgram = Program(startNode: start)
            tryUpdateProgram(to: newProgram)
            
            //TODO: Call delegate when these errors occur a number of times? (to ensure accuracy)
        } catch CardSequenceError.missingStart {
            //print("Could not find start card")
        } catch CardSequenceError.unknownCode(let code) {
            print("Found unexpected code: \(code)")
        } catch {
            print("Unexpected error")
        }
    }
    
    private func tryUpdateProgram(to newProgram: Program) {
        if (isProgramBigger(than: newProgram)) {
            programUncertainty += 1
            if programUncertainty < ProgramEditor.programUncertaintyLimit {
                return
            }
        }
        
        currentProgram = newProgram
        programUncertainty = 0
        
        delegate?.programEditor(self, createdNew: newProgram)
    }
    
    func isProgramBigger(than otherProgram: Program) -> Bool {
        return isNode(currentProgram?.start, moreDetailedThan: otherProgram.start)
    }
    
    func isNode(_ currentNode: CardNode?, moreDetailedThan newNode: CardNode?) -> Bool {
        if newNode == nil {
            return currentNode != nil
        }
        
        guard let currentNode = currentNode else {
            return false
        }
        
        if newNode!.successors.count < currentNode.successors.count {
            return true
        }
        
        for (index, node) in currentNode.successors.enumerated() {
            if isNode(node, moreDetailedThan: newNode!.successors[index]) {
                return true
            }
        }
        
        return false
    }
}

protocol ProgramEditorDelegate: class {
    func programEditor(_ programEditor: ProgramEditor, createdNew program: Program)
}
