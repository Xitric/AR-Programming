//
//  ResourceComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 07/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import GameplayKit

public class ResourceComponent: GKComponent {

    public let resourceIdentifier: String

    public init(resourceIdentifier: String) {
        self.resourceIdentifier = resourceIdentifier
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
