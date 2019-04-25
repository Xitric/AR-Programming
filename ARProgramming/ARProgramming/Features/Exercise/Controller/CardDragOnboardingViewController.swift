//
//  CardDragOnboardingViewController.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 24/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardDragOnboardingViewController: UIViewController, GameplayController {
    
    @IBOutlet weak var cardDragAnimation: UIImageView!
    
    //MARK: - Injected properties
    weak var delegate: AuxiliaryExerciseViewDelegate?
    var levelViewModel: LevelViewModeling?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createDragAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardDragAnimation.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cardDragAnimation.stopAnimating()
    }
    
    private func createDragAnimation() {
        cardDragAnimation.animationImages = UIImage.loadAnimation(named: "SwipeCard", withFrames: 50)
        cardDragAnimation.animationDuration = 2.8
    }
    
    @IBAction func onDismiss() {
        delegate?.auxiliaryViewCompleted(self)
    }
}
