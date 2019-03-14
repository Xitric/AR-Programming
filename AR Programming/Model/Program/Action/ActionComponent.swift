//
//  ActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ActionComponent: Component {
    
    var onComplete: (() -> Void)?
    
    func complete() {
        entity?.removeComponent(ofType: type(of: self))
        onComplete?()
    }
}
