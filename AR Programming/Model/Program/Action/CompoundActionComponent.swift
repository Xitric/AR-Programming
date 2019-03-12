//
//  CompoundActionComponent.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CompoundActionComponent: ActionComponent {
    
    let firstAction: ActionComponent
    let secondAction: ActionComponent
    
    init(_ firstAction: ActionComponent, _ secondAction: ActionComponent) {
        self.firstAction = firstAction
        self.secondAction = secondAction
        super.init(duration: 0)
        
        firstAction.onComplete = { [weak self] in
            if let entity = self?.entity {
                entity.addComponent(secondAction)
            }
        }
        
        secondAction.onComplete = { [weak self] in
            self?.complete()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
