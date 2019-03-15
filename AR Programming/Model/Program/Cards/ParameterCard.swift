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
    let internalName = "parameter"
    let summary = "Tal for dit program."
    let description: String
    var parameter: Int
    
    init(paremeter: Int) {
        self.parameter = paremeter
        self.description = "Brug dette kort til at fortælle hvor mange gange et loop skal gentage sig. Dette tal kortet \(parameter) skal sættes ovenfor eller under et gentagelses kort."
    }
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        return nil
    }
}
