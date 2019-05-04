//
//  GKEntity+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

public extension GKEntity {
    func component<ComponentType>(subclassOf superClass: ComponentType.Type) -> ComponentType? where ComponentType: GKComponent {
        for component in components {
            if type(of: component).isSubclass(of: superClass) {
                return component as? ComponentType
            }
        }

        return nil
    }

    func components<ComponentType>(subclassOf superClass: ComponentType.Type) -> [ComponentType] where ComponentType: GKComponent {
        var result = [ComponentType]()

        for component in components {
            if let matchingComponent = component as? ComponentType {
                result.append(matchingComponent)
            }
        }

        return result
    }
}
