//
//  BranchLevelSelectViewController.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 19/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import Level

class BranchLevelSelectViewController: UIViewController {

    var levelRepository: LevelRepository!
    var levelViewModel: LevelViewModeling!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arContainer = segue.destination as? ARContainerViewController {
            levelViewModel.display(level: levelRepository.levelWithItem)
            arContainer.levelViewModel = levelViewModel
        }
    }
}
