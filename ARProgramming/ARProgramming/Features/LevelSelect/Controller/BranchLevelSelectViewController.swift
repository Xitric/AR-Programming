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

    // MARK: - Observers
    private var levelObserver: Observer?

    // MARK: - Injected properties
    var viewModel: LevelSelectViewModeling!

    deinit {
        levelObserver?.release()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        levelObserver = viewModel.level.observeFuture { [weak self] _ in
            self?.performSegue(withIdentifier: "freePlaySegue", sender: self)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        levelObserver?.release()
    }

    @IBAction func onFreePlay(_ sender: Any) {
        viewModel.loadLevel(withNumber: 9000)
    }
}
