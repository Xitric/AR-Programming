//
//  HiddenTabBarViewController.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class HiddenTabBarViewController: UITabBarController, GameplayController {
    
    private var level: Level?
    private var arController: ARController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.isHidden = true
    }

    func enter(withLevel level: Level?, inEnvironment arController: ARController?) {
        self.level = level
        self.arController = arController
    }
    
    func exit(withLevel level: Level?, inEnvironment arController: ARController?) {
        self.level = nil
        self.arController = nil
    }
    
    func goToViewControllerWith(index: Int) {
        if let gameplayController = selectedViewController as? GameplayController {
            gameplayController.exit(withLevel: level, inEnvironment: arController)
        }
        
        self.selectedIndex = index
        
        if let gameplayController = selectedViewController as? GameplayController {
            gameplayController.enter(withLevel: level, inEnvironment: arController)
        }
    }
}
