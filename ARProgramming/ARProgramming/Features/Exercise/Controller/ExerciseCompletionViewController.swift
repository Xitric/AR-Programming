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
    var viewModel: ExerciseCompletionViewModeling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextButton.isHidden = !viewModel.hasNextLevel
        noMoreExercisesLabel.isHidden = viewModel.hasNextLevel
    }
    
    @IBAction func onNext() {
        viewModel.goToNext()
    }
    
    @IBAction func onRestart() {
        viewModel.reset()
    }
}
