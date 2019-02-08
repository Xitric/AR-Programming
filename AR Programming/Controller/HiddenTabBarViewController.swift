//
//  HiddenTabBarViewController.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class HiddenTabBarViewController: UITabBarController {
    
    var level: Level?
    var arController: ARController?
    
    var levelViewController: LevelViewController? {
        didSet {
            arController?.planeDetectorDelegate = levelViewController
            levelViewController?.arController = arController
            levelViewController?.level = level
        }
    }
    
    var scanViewController: ScanViewController? {
        didSet {
            arController?.cardScannerDelegate = scanViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.isHidden = true
    }

    func goToViewControllerWith(index: Int) {
        self.selectedIndex = index
    }
   
}
