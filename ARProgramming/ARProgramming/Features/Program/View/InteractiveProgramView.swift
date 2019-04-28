//
//  InteractiveProgramView.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 27/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import ProgramModel

class InteractiveProgramView: ProgramView {
    
    //MARK: - Observers
    private var activeCardObserver: Observer?
    
    //MARK: - Injected properties
    override var viewModel: ProgramsViewModeling! {
        get {
            return super.viewModel
        }
        set {
            super.viewModel = newValue
            activeCardObserver = viewModel.activeCard.observeFuture { [weak self] cardNode in
                self?.highlight(cardNode: cardNode)
            }
        }
    }
    
    deinit {
        activeCardObserver?.release()
    }
    
    private func highlight(cardNode: CardNodeProtocol?) {
        for subview in self.arrangedSubviews {
            if let functionView = subview as? FunctionView {
                functionView.highlightNode = cardNode
            }
        }
    }
    
    //TODO: Touch gesture on cards and callback to delegate?
}
