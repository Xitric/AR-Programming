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
    
    //MARK: - Observers
    private var levelObserver: Observer!
    
    //MARK: - Injected properties
    var viewModel: LevelSelectViewModeling! {
        didSet {
            levelObserver = viewModel.level.observeFuture { [weak self] level in
                self?.performSegue(withIdentifier: "freePlaySegue", sender: self)
            }
        }
    }
    
    deinit {
        levelObserver.release()
    }
    
    @IBAction func onFreePlay(_ sender: Any) {
        viewModel.loadLevel(withNumber: 9000)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arContainer = segue.destination as? ARContainerViewController {
            arContainer.level = viewModel.level
        }
    }
}
