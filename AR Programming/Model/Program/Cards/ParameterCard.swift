//
//  ParameterCard.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct ParameterCard: Card {
    
    let name = "Tal"
    var internalName: String {
        return "param\(parameter)"
    }
    let summary = "Tal for dit program."
    let description: String
    let type = CardType.parameter
    var parameter: Int
    
    init(paremeter: Int) {
        self.parameter = paremeter
        self.description = "Brug dette kort til at fortælle, at et gentagelseskort skal gentage sig \(parameter) gange. Dette talkort skal placeres over eller under et gentagelseskort."
    }
    
    func getAction(forEntity entity: Entity) -> ActionComponent? {
        return nil
    }
}
