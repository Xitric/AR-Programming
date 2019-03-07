//
//  NumberCard.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

struct ParameterCard: StatementCard {
    
    let name = "Tal"
    let internalName = "parameter"
    let summary = "tal for dit program."
    let description: String
    var parameter: Int
    
    init(paremeter: Int) {
        self.parameter = paremeter
        self.description = "Brug dette kort til at noge med tal \(parameter)."
    }
    
    func getAction(for robot: SCNNode) -> SCNAction? {
        return nil
    }
    
    func getContinuationIndex() -> Int {
        print("Parameter")
        return 0
    }
}
