//
//  QuantityComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 08/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

class QuantityComponent: GKComponent {

    let type: String
    var quantity: Int

    init(type: String, quantity: Int) {
        self.type = type
        self.quantity = quantity
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
