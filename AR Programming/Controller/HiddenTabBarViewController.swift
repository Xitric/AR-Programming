//
//  HiddenTabBarViewController.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class HiddenTabBarViewController: UITabBarController {
    
    private var levelViewModel: LevelViewModel?
    private var arController: ARController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.isHidden = true
        
        goToViewControllerWith(index: 0)
    }
    
    func goToViewControllerWith(index: Int) {
        if let gameplayController = selectedViewController as? GameplayController {
            gameplayController.exit(withLevel: levelViewModel, inEnvironment: arController)
        }
        
        self.selectedIndex = index
        
        if let gameplayController = selectedViewController as? GameplayController {
            gameplayController.enter(withLevel: levelViewModel, inEnvironment: arController)
        }
    }
}

// MARK: - GamePlayController
extension HiddenTabBarViewController: GameplayController {
    func enter(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?) {
        self.levelViewModel = levelViewModel
        self.arController = arController
    }
    
    func exit(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?) {
        self.levelViewModel = nil
        self.arController = nil
    }
}
