//
//  CardGraphDeserializer.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 01/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

class CardGraphDeserializer: CardGraphDeserializerProtocol {

    private let factory: CardNodeFactory

    init(factory: CardNodeFactory) {
        self.factory = factory
    }

    func serialize(_ program: ProgramProtocol) -> Data? {
        if let start = program.start {
            let functions = [toJsonFunction(programNode: start)]
            return try? JSONEncoder().encode(functions)
        }

        return nil
    }

    func serialize(_ editor: ProgramEditorProtocol) -> Data? {
        var functions = [JsonFunction]()
        for program in editor.allPrograms {
            if let start = program.start {
                functions.append(toJsonFunction(programNode: start))
            }
        }

        return try? JSONEncoder().encode(functions)
    }

    private func toJsonFunction(programNode: CardNodeProtocol) -> JsonFunction {
        var cards = [JsonCard]()
        populateCards(&cards, from: programNode)
        return JsonFunction(cards: cards)
    }

    private func populateCards(_ cards: inout [JsonCard], from node: CardNodeProtocol) {
        if let code = factory.cardCode(fromInternalName: node.card.internalName) {
            cards.append(JsonCard(x: node.position.x,
                                  y: node.position.y,
                                  width: node.size.x,
                                  height: node.size.y,
                                  payload: code))
        }

        for child in node.children {
            populateCards(&cards, from: child)
        }
    }

    func deserialize(from data: Data) throws -> ProgramEditorProtocol {
        let functions = try JSONDecoder().decode([JsonFunction].self, from: data)
        let editor = ProgramEditor(factory: factory)

        for function in functions {
            let set = makeObservationSet(fromFunction: function)
            let graph = ObservationGraph(observationSet: set)
            if let start = try? ObservationGraphCardNodeBuilder()
                .using(factory: factory)
                .createFrom(graph: graph)
                .getResult() {
                editor.save(Program(startNode: start))
            }
        }

        return editor
    }

    private func makeObservationSet(fromFunction function: JsonFunction) -> ObservationSet {
        var observationSet = ObservationSet()

        for card in function.cards {
            let observation = ObservationNode(payload: card.payload,
                                              position: simd_double2(Double(card.x), Double(card.y)),
                                              width: card.width,
                                              height: card.height)

            observationSet.add(observation)
        }

        return observationSet
    }
}

private struct JsonCard: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
    let payload: String
}

private struct JsonFunction: Codable {
    let cards: [JsonCard]
}
