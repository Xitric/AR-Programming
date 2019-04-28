//
//  SurfaceDetectionViewController.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 13/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import Level

/// A controller for performing surface detection before an exercise can begin.
class SurfaceDetectionViewController: UIViewController, GameplayController {

    @IBOutlet weak var surfaceDetectionAnimation: UIImageView!
    @IBOutlet weak var surfaceDetectionLabel: SubtitleLabel!
    @IBOutlet weak var planePlacementLabel: SubtitleLabel!
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet var surfacePlacementGesture: UITapGestureRecognizer!
    
    //MARK: - Observers
    private var planeObserver: Observer?
    
    //MARK: - Injected properties
    var viewModel: SurfaceDetectionViewModeling! {
        didSet {
            planeObserver = viewModel.planeDetected.observeFuture { [weak self] in
                self?.onPlaneDetected()
            }
        }
    }
    var levelViewModel: LevelSceneViewModeling!
    var level: ObservableProperty<LevelProtocol>? {
        didSet {
            if let level = level {
                levelViewModel.setLevel(level: level)
            }
        }
    }
    weak var delegate: AuxiliaryExerciseViewDelegate?
    
    deinit {
        planeObserver?.release()
    }
    
    //MARK: - Control
    private func onPlaneDetected() {
        surfaceDetectionAnimation.stopAnimating()
        surfaceDetectionAnimation.isHidden = true
        surfaceDetectionLabel.isHidden = true
        
        planePlacementLabel.isHidden = false
        placeButton.isHidden = false
        surfacePlacementGesture.isEnabled = true
    }
    
    @IBAction func onPlaceAction(_ sender: Any) {
        if let levelViewModel = levelViewModel {
            viewModel.placeLevel(levelViewModel)
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
