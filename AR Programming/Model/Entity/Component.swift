//
//  Component.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 04/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

class Component: GKComponent {
    
    weak var entityManager: EntityManager? {
        didSet {
            if entityManager != nil {
                didAddToEntityManager()
            }
        }
    }
    
    func didAddToEntityManager() {
        
    }
}
