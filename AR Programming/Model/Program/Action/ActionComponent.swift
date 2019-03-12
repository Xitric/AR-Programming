//
//  ActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ActionComponent: Component {
    
    let duration: TimeInterval
    var onComplete: (() -> Void)?
    
    init(duration: TimeInterval) {
        self.duration = duration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func complete() {        
        entity?.removeComponent(ofType: type(of: self))
        onComplete?()
    }
}
