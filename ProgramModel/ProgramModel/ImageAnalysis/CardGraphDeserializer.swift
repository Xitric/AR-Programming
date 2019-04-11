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
    
    private static let cardSide = 0.8
    private let factory: CardNodeFactory
    
    init(factory: CardNodeFactory) {
        self.factory = factory
    }
    
    func deserialize(from data: Data) throws -> ProgramEditorProtocol {
        let functions = try JSONDecoder().decode([JsonFunction].self, from: data)
        let editor = ProgramEditor(factory: factory)
        
        for function in functions {
            let set = makeObservationSet(fromFunction: function)
            editor.barcodeDetector(found: set)
            editor.saveProgram()
        }
        
        return editor
    }
    
    private func makeObservationSet(fromFunction function: JsonFunction) -> ObservationSet {
        var observationSet = ObservationSet()
        
        for card in function.cards {
            let observation = ObservationNode(payload: card.payload,
                                              position: simd_double2(Double(card.x), Double(card.y)),
                                              width: CardGraphDeserializer.cardSide,
                                              height: CardGraphDeserializer.cardSide)
            
            observationSet.add(observation)
        }
        
        return observationSet
    }
}

private struct JsonCard: Decodable {
    let x: Int
    let y: Int
    let payload: String
}

private struct JsonFunction: Decodable {
    let cards: [JsonCard]
}
