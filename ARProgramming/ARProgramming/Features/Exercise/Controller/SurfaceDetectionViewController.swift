//
//  SurfaceDetectionViewController.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 13/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

/// A controller for performing surface detection before an exercise can begin.
class SurfaceDetectionViewController: UIViewController, GameplayController {

    @IBOutlet weak var surfaceDetectionAnimation: UIImageView!
    @IBOutlet weak var surfaceDetectionLabel: SubtitleLabel!
    @IBOutlet weak var planePlacementLabel: SubtitleLabel!
    @IBOutlet weak var placeButton: UIButton!
    
    //MARK: - Injected properties
    weak var delegate: AuxiliaryExerciseViewDelegate?
    var levelViewModel: LevelViewModeling?
    var planeViewModel: PlaneViewModel! {
        didSet {
            planeViewModel.planeDetected = { [weak self] in
                self?.onPlaneDetected()
            }
        }
    }
    
    //MARK: - Control
    private func onPlaneDetected() {
        surfaceDetectionAnimation.stopAnimating()
        surfaceDetectionAnimation.isHidden = true
        surfaceDetectionLabel.isHidden = true
        
        planePlacementLabel.isHidden = false
        placeButton.isHidden = false
    }
    
    @IBAction func onPlaceAction(_ sender: Any) {
        if let levelViewModel = levelViewModel {
            planeViewModel.placeLevel(levelViewModel)
            delegate?.auxiliaryViewCompleted(self)
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createPlaneAnimation()
        surfaceDetectionAnimation.startAnimating()
    }
    
    private func createPlaneAnimation() {
        surfaceDetectionAnimation.animationImages = UIImage.loadAnimation(named: "ScanSurface", withFrames: 50)
        surfaceDetectionAnimation.animationDuration = 2.8
    }
}
