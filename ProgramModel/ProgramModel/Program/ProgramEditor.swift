//
//  ProgramEditor.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class ProgramEditor: ProgramEditorProtocol, ProgramState, CardGraphDetectorDelegate {
    
    private let factory: CardNodeFactory
    private var currentProgram: Program?
    private let detector: BarcodeDetector
    private var allStoredPrograms = [String:Program]()
    
    weak var delegate: ProgramEditorDelegate?
    
    var main: ProgramProtocol {
        return allStoredPrograms["function0"] ?? Program(startNode: nil)
    }
    var allPrograms: [ProgramProtocol] {
        return Array(allStoredPrograms.values)
    }
    
    init(factory: CardNodeFactory) {
        self.factory = factory
        
        let detectorState = CardGraphDetector()
        detector = BarcodeDetector(state: detectorState)
        detectorState.delegate = self
    }
    
    func newFrame(_ frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation, frameWidth: Double, frameHeight: Double) {
        detector.analyze(frame: frame, oriented: orientation, frameWidth: frameWidth, frameHeight: frameHeight)
    }
    
    func saveProgram() {
        if let cardIdentifier = currentProgram?.start?.card.internalName {
            currentProgram?.state = self
            allStoredPrograms[cardIdentifier] = currentProgram
        }
    }
    
    func reset() {
        allStoredPrograms.removeAll()
    }
    
    func graphDetector(found graph: ObservationGraph) {
        do {
            let start = try ObservationGraphCardNodeBuilder()
                .using(factory: factory)
                .createFrom(graph: graph)
                .getResult()
            
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
    
    //MARK: ProgramState
    func getProgram(forCard card: Card) -> Program? {
        return allStoredPrograms[card.internalName]
    }
}
