//
//  LevelViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import AVFoundation
import ProgramModel
import Level

class LevelViewController: UIViewController {
    
    //MARK: View
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var detectButton: UIButton!
    @IBOutlet weak var executeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var planeDetectionHint: SubtitleLabel!
    @IBOutlet weak var planePlacementHint: SubtitleLabel!
    @IBOutlet weak var levelInfo: SubtitleLabel!
    @IBOutlet weak var winDescription: SubtitleLabel!
    @IBOutlet weak var winLabel: UILabel!
    
    @IBOutlet weak var planeDetectionAnimation: UIImageView!
    
    //MARK: Sound
    var audioController: AudioController? {
        didSet {
            winSound = audioController?.makeSound(withName: "win.wav")
            pickupSound = audioController?.makeSound(withName: "pickup.wav")
        }
    }
    private var winSound: AVAudioPlayer?
    private var pickupSound: AVAudioPlayer?

    //MARK: State
    private var programEditor: ProgramEditorProtocol?
    private var levelViewModel: LevelViewModel? {
        didSet {
            winLabel.isHidden = true
            winDescription.isHidden = true
            levelViewModel?.levelModel.delegate = self
            programEditor?.reset()
        }
    }
    private var currentPlane: Plane? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                let planeDetected = self.currentPlane != nil
                
                self.placeButton.isHidden = !planeDetected
                self.planePlacementHint.isHidden = !planeDetected
                
                self.planeDetectionHint.isHidden = planeDetected || !self.shouldDetectPlanes
                self.planeDetectionAnimation.isHidden = planeDetected || !self.shouldDetectPlanes
                
                if planeDetected {
                    self.planeDetectionAnimation.stopAnimating()
                } else {
                    self.planeDetectionAnimation.startAnimating()
                }
            }
        }
    }
    private var shouldDetectPlanes: Bool {
        return levelViewModel?.levelView.parent == nil
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createPlaneAnimation()
    }
    
    private func createPlaneAnimation() {
        planeDetectionAnimation.animationImages = UIImage.loadAnimation(named: "ScanSurface", withFrames: 50)
        planeDetectionAnimation.animationDuration = 2.8
        planeDetectionAnimation.startAnimating()
    }
    
    // MARK: - Button actions    
    @IBAction func detectCards(_ sender: UIButton) {
        programEditor?.saveProgram()
        programEditor?.main.delegate = self
        
        executeButton.isHidden = false
        resetButton.isHidden = false
    }
    
    @IBAction func executeSequence(_ sender: UIButton) {
        if let levelViewModel = levelViewModel {
            let player = levelViewModel.player
            programEditor?.main.run(on: player)
        }
    }
    
    @IBAction func resetLevel(_ sender: UIButton) {
        levelViewModel?.levelModel.reset()
        programEditor?.main.delegate = nil
        programEditor?.reset()
        
        detectButton.isHidden = false
        executeButton.isHidden = true
        resetButton.isHidden = true
    }
    
    @IBAction func placePlane(_ sender: UIButton) {
        if var plane = currentPlane {
            plane.groundNode = nil
            if let levelViewModel = levelViewModel {
                plane.root.addChildNode(levelViewModel.levelView)
            }
            currentPlane = nil
        }
        
        detectButton.isHidden = false
    }
}

// MARK: - GameplayController
extension LevelViewController: GameplayController {
    func enter(withState state: GameState) {
        state.arController.planeDetectorDelegate = self
        
        self.programEditor = state.programEditor
        if self.levelViewModel?.levelModel.levelNumber != state.levelViewModel.levelModel.levelNumber {
            self.levelViewModel = state.levelViewModel
            
            DispatchQueue.main.async { [unowned self] in
                let info = self.levelViewModel?.levelModel.infoLabel
                self.levelInfo.text = info
                self.levelInfo.isHidden = info == nil
            }
        }
    }
    
    func exit(withState state: GameState) {
        state.arController.planeDetectorDelegate = nil
    }
}

// MARK: - PlaneDetectorDelegate
extension LevelViewController: PlaneDetectorDelegate {
    func shouldDetectPlanes(_ detector: ARController) -> Bool {
        return shouldDetectPlanes
    }
    
    func planeDetector(_ detector: ARController, found plane: Plane) {
        currentPlane = plane
    }
}

// MARK: - ProgramDelegate
extension LevelViewController: ProgramDelegate {
    func programBegan(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [unowned self] in
            self.executeButton.isEnabled = false
            self.resetButton.isEnabled = false
        }
    }
    
    //TODO: A method for when we are about to execute a card so that we can highlight it
    func program(_ program: ProgramProtocol, executed card: Card) {
        
    }
    
    func programEnded(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [unowned self] in
            self.executeButton.isEnabled = true
            self.resetButton.isEnabled = true
        }
    }
}

// MARK: - LevelDelegate
extension LevelViewController: LevelDelegate {
    
    func levelCompleted(_ level: LevelProtocol) {
        self.winSound?.play()
        
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = false
            self.winDescription.isHidden = false
        }
    }
    
    func levelReset(_ level: LevelProtocol) {
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = true
            self.winDescription.isHidden = true
        }
    }
    
    func levelInfoChanged(_ level: LevelProtocol, info: String?) {
        DispatchQueue.main.async { [unowned self] in
            self.levelInfo.text = info
            self.levelInfo.isHidden = info == nil
        }
    }
}