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
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noMoreExercisesLabel: UILabel!
    
    //MARK: - Injected properties
    var levelViewModel: LevelViewModeling? {
        didSet {
            let hasNextLevel = levelViewModel?.level.value?.unlocks != nil
            nextButton.isHidden = !hasNextLevel
            noMoreExercisesLabel.isHidden = hasNextLevel
        }
    }
    
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
