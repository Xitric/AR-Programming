//
//  ProgramEditor.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

public class ProgramEditor: CardGraphDetectorDelegate, ProgramState {
    
    private let factory: CardNodeFactory
    private var currentProgram: Program?
    private let detector: BarcodeDetector
    private var allStoredPrograms = [String:Program]()
    
    public weak var delegate: ProgramEditorDelegate?
    
    public var main: Program {
        return allStoredPrograms["function0"] ?? Program(startNode: nil)
    }
    public var allPrograms: [Program] {
        return Array(allStoredPrograms.values)
    }
    
    init(factory: CardNodeFactory) {
        self.factory = factory
        
        let detectorState = CardGraphDetector()
        detector = BarcodeDetector(state: detectorState)
        detectorState.delegate = self
    }
    
    //Should only be called from the main thread
    public func newFrame(_ frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation, frameWidth: Double, frameHeight: Double) {
        detector.analyze(frame: frame, oriented: orientation, frameWidth: frameWidth, frameHeight: frameHeight)
    }
    
    public func saveProgram() {
        if let cardIdentifier = currentProgram?.start?.card.internalName {
            currentProgram?.state = self
            allStoredPrograms[cardIdentifier] = currentProgram
        }
    }
    
    public func reset() {
        allStoredPrograms.removeAll()
    }
    
    func graphDetector(found graph: ObservationGraph) {
        do {
            if let startObservation = graph.firstNode(withPayloadIn: factory.functionDeclarationCodes) {
                
                let start = try ObservationGraphCardNodeBuilder()
                    .using(factory: factory)
                    .createFrom(graph: graph)
                    .using(node: startObservation)
                    .getResult()
                
                currentProgram = Program(startNode: start)
            }
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
    
    //MARK: ProgramState
    func getProgram(forCard card: Card) -> Program? {
        return allStoredPrograms[card.internalName]
    }
}

public protocol ProgramEditorDelegate: class {
    func programEditor(_ programEditor: ProgramEditor, createdNew program: Program)
}
