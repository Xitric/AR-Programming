//
//  CardGraphDeserializer.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 01/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

public class CardGraphDeserializer {
    
    private static let cardSide = 0.8
    
    public init() {
        
    }
    
    public func deserialize(from data: Data) throws -> ProgramEditor {
        let functions = try JSONDecoder().decode([JsonFunction].self, from: data)
        let editor = ProgramEditor()
        
        for function in functions {
            let graph = makeGraph(fromFunction: function)
            editor.graphDetector(found: graph)
            editor.saveProgram()
        }
        
        return editor
    }
    
    private func makeGraph(fromFunction function: JsonFunction) -> ObservationGraph {
        var observationSet = ObservationSet()
        
        for card in function.cards {
            let observation = ObservationNode(payload: card.payload,
                                              position: simd_double2(Double(card.x), Double(card.y)),
                                              width: CardGraphDeserializer.cardSide,
                                              height: CardGraphDeserializer.cardSide)
            
            observationSet.add(observation)
        }
        
        return ObservationGraph(observationSet: observationSet)
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
