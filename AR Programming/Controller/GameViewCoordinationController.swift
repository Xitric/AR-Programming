//
//  GameViewCoordinationController.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

/// This controller is responsible for switching between the curently active controller while the user is playing a level.
///
/// Initially the surface scanning controller must be active, then the level controller is active, and occasionally the card detail controller must be active. Only one of these controllers can be active at the same time.
class GameViewCoordinationController: UITabBarController {
    
    private var gameState: GameState?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.isHidden = true
        
        goToLevelView()
    }

    private func goToViewController(withIndex index: Int) {
        if let gameplayController = super.selectedViewController as? GameplayController,
            let gameState = gameState {
            gameplayController.exit(withState: gameState)
        }
        
        self.selectedIndex = index
        
        if let gameplayController = super.selectedViewController as? GameplayController,
            let gameState = gameState {
            gameplayController.enter(withState: gameState)
        }
    }
    
    func goToLevelView() {
        goToViewController(withIndex: 0)
    }
    
    func goToCardDescriptionView(withCard card: Card) {
        goToViewController(withIndex: 1)
        if let descriptionView = selectedViewController as? CardDescriptionViewController {
            descriptionView.card = card
        }
    }
}

// MARK: - GamePlayController
extension GameViewCoordinationController: GameplayController {
    func enter(withState state: GameState) {
        self.gameState = state
    }
    
    func exit(withState state: GameState) {
        self.gameState = nil
    }
}
