//
//  BranchLevelSelectViewController.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 12/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import Level

class BranchLevelSelectViewController: UIViewController {
    
    var levelRepository: LevelRepository!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arContainer = segue.destination as? ARContainerViewController {
            arContainer.level = levelRepository.emptylevel
        }
    }
    
}
