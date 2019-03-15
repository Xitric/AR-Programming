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
    
    private var currentProgram: Program?
    private var savedProgram: Program?
    private let detector: BarcodeDetector
    
    weak var delegate: ProgramEditorDelegate?
    
    var program: Program {
        get {
            return savedProgram == nil ? Program(startNode: nil) : savedProgram!
        }
    }
    
    init() {
        let state = CardGraphDetector()
        detector = BarcodeDetector(state: state)
        state.delegate = self
    }
    
    //Should only be called from the main thread
    func newFrame(_ frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation, frameWidth: Double, frameHeight: Double) {
        detector.analyze(frame: frame, oriented: orientation, frameWidth: frameWidth, frameHeight: frameHeight)
    }
    
    func saveProgram() {
        savedProgram = currentProgram
    }
    
    func reset() {
        savedProgram = nil
    }
    
    func graphDetector(_ detector: CardGraphDetector, found graph: ObservationGraph) {
        do {
            let start = try CardNodeFactory.instance.build(from: graph)
            currentProgram = Program(startNode: start)
        } catch CardSequenceError.missingStart {
            currentProgram = nil
            
            //TODO: Call delegate when these errors occur a number of times? (to ensure accuracy)
        } catch CardSequenceError.unknownCode(let code) {
            print("Found unexpected code: \(code)")
        } catch CardSequenceError.syntax(let message){
            print("Syntax error: \(message)")
        } catch {
            print("Unexpected error")
        }
        
        delegate?.programEditor(self, createdNew: currentProgram ?? Program(startNode: nil))
    }
}

protocol ProgramEditorDelegate: class {
    func programEditor(_ programEditor: ProgramEditor, createdNew program: Program)
}
