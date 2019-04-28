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

class ExerciseCompletionViewController: UIViewController, GameplayController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noMoreExercisesLabel: UILabel!
    
    //MARK: - Injected properties
    var viewModel: ExerciseCompletionViewModeling!
    var level: ObservableProperty<LevelProtocol>? {
        didSet {
            if let level = level {
                viewModel.setLevel(level: level)
                nextButton.isHidden = !viewModel.hasNextLevel
                noMoreExercisesLabel.isHidden = viewModel.hasNextLevel
            }
        }
    }
    
    override func viewDidLoad() {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func onNext() {
        viewModel.goToNext()
    }
    
    @IBAction func onRestart() {
        viewModel.reset()
    }
}
