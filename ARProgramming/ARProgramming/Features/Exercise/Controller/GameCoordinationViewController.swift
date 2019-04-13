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

/// This controller is responsible for switching between the curently active controller while the user is playing a level.
///
/// Initially the level controller is active, and occasionally the card detail controller must be active. Only one of these controllers can be active at the same time.
class GameCoordinationViewController: UIViewController, GameplayController {
    
    private var childViewController: UIViewController? {
        return children.first
    }
    
    //MARK: - Injected properties
    var levelViewModel: LevelViewModel?
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
        
        (controller as? GameplayController)?.levelViewModel = levelViewModel
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
    
    func goToCardDescriptionView(withCard card: Card?) {
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
