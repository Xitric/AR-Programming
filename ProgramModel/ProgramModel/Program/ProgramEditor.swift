//
//  ProgramEditor.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

class ProgramEditor: ProgramEditorProtocol, ProgramState, BarcodeDetectorDelegate {

    private let factory: CardNodeFactory
    private let detector: BarcodeDetector
    private var allStoredPrograms = [String: ProgramProtocol]()

    weak var delegate: ProgramEditorDelegate?

    var main: ProgramProtocol {
        return allStoredPrograms["function0a"] ?? Program(startNode: nil)
    }
    var allPrograms: [ProgramProtocol] {
        return Array(allStoredPrograms.values)
    }
    var allCards = [CardNodeProtocol]()

    init(factory: CardNodeFactory) {
        self.factory = factory

        detector = BarcodeDetector()
        detector.delegate = self
    }

    func newFrame(_ frame: CVPixelBuffer, oriented orientation: CGImagePropertyOrientation, frameWidth: Double, frameHeight: Double) {
        detector.analyze(frame: frame, oriented: orientation, frameWidth: frameWidth, frameHeight: frameHeight)
    }

    func save(_ program: ProgramProtocol) {
        if let cardIdentifier = program.start?.card.internalName {
            if let program = program as? Program {
                program.state = self
            }

            allStoredPrograms[cardIdentifier] = program
        }
    }

    func reset() {
        allStoredPrograms.removeAll()
    }

    func barcodeDetector(found nodes: ObservationSet) {
        handleDetectedNodes(nodes)
        handleDetectedProgram(nodes)
    }

    private func handleDetectedNodes(_ nodeSet: ObservationSet) {
        allCards = nodeSet.nodes
            .map {
                let cardNode = try? factory.cardNode(withCode: $0.payload)
                cardNode?.position = $0.position
                cardNode?.size = simd_double2($0.width, $0.height)
                return cardNode
            }.filter {
                $0 != nil
            }.map {
                $0!
        }
    }

    private func handleDetectedProgram(_ nodeSet: ObservationSet) {
        var detectedProgram = Program(startNode: nil)

        do {
            let graph = ObservationGraph(observationSet: nodeSet)
            let start = try ObservationGraphCardNodeBuilder()
                .using(factory: factory)
                .createFrom(graph: graph)
                .getResult()

            detectedProgram = Program(startNode: start)
        } catch CardSequenceError.missingStart {
           //Ignore
        } catch CardSequenceError.unknownCode(let code) {
            print("Found unexpected code: \(code)")
        } catch CardSequenceError.syntax(let message) {
            print("Syntax error: \(message)")
        } catch {
            print("Unexpected error")
        }

        delegate?.programEditor(self, createdNew: detectedProgram)
    }

    // MARK: ProgramState
    func getProgram(forCardWithName internalName: String) -> ProgramProtocol? {
        return allStoredPrograms[internalName]
    }
}
