//
//  CompoundActionComponent.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 14/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CompoundActionComponent: ActionComponent {
    
    private let firstAction: ActionComponent
    private let secondAction: ActionComponent
    
    init(_ first: ActionComponent, _ second: ActionComponent) {
        firstAction = first
        secondAction = second
        super.init()
        
        firstAction.onComplete = { [weak self] in
            self?.entity?.addComponent(self!.secondAction)
        }
        
        secondAction.onComplete = { [weak self] in
            self?.complete()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        entity?.addComponent(firstAction)
    }
}
