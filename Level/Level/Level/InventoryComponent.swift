//
//  InventoryComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 21/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

class InventoryComponent: GKComponent {

    private(set) var quantities = [String: Int]()

    func add(quantity: Int, ofType type: String) {
        let currentQuantity = quantities[type] ?? 0
        quantities[type] = currentQuantity + quantity
    }

    func reset() {
        quantities.removeAll()
    }
}
