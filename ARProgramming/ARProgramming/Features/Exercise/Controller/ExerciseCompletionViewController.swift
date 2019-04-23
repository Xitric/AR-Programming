//
//  ExerciseCompletionViewController.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 23/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import Level

class ExerciseCompletionViewController: UIViewController {
    
    //MARK: - Injected properties
    var levelViewModel: LevelViewModeling?
    
    override func viewDidLoad() {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func onNext() {
        levelViewModel?.goToNext()
    }
    
    @IBAction func onRestart() {
        levelViewModel?.reset()
    }
}
