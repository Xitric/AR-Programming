//
//  GameCoordinationViewController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 25/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

//This implementation is inspired by:
//https://cocoacasts.com/managing-view-controllers-with-container-view-controllers/

/// This controller is responsible for switching between the currently active controller while the user is playing a level.
///
/// This controller is inspired by the Coordinator, whose responsibility is to manage the navigation between a set of child view controllers / coordinators. In this way, the child view controllers can be independent of each other and send callbacks only back to their coordinator by means of a delegate.
class GameCoordinationViewController: UIViewController {
    
    private var childViewController: UIViewController? {
        return children.first
    }
    
    //MARK: - Injected properties
    var surfaceViewController: UIViewController!
    var levelViewController: UIViewController!
    var cardViewController: UIViewController!
    
    //MARK: - View controller navigation
    private func showViewController(controller: UIViewController) {
        if let oldChild = childViewController {
            if oldChild == controller {
                return
            }
            
            removeViewController(oldChild)
        }
        
        addViewController(controller)
    }
    
    private func addViewController(_ controller: UIViewController) {
        addChild(controller)
        
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        controller.didMove(toParent: self)
    }
    
    private func removeViewController(_ controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showViewController(controller: surfaceViewController)
    }
    
    func goToCardDescriptionView(withCard card: Card) {
        showViewController(controller: cardViewController)
        if let descriptionView = childViewController as? CardDescriptionViewController {
            descriptionView.card = card
        }
    }
}

//MARK: - AuxiliaryExerciseViewDelegate
extension GameCoordinationViewController: AuxiliaryExerciseViewDelegate {
    func auxiliaryViewCompleted(_ controller: UIViewController) {
        showViewController(controller: levelViewController)
    }
}
