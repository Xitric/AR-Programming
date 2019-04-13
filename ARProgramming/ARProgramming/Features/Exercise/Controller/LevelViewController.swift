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

class LevelViewController: UIViewController, GameplayController {
    
    //MARK: - View
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
    
    //MARK: - Injected properties
    var levelViewModel: LevelViewModel? {
        didSet {
            //TODO: Can we move this responsibility elsewhere?
            //  Like always inject a new level object?
            levelViewModel?.levelModel?.reset()
            
            levelViewModel?.levelModel?.delegate = self
            levelViewModel?.levelChanged = { [weak self] in
                self?.onLevelChanged()
            }
            levelViewModel?.levelAnchored = { [weak self] in
                self?.onLevelPlaced()
            }
        }
    }
    var planeViewModel: PlaneViewModel! {
        didSet {
            planeViewModel.planeDetected = { [weak self] in
                self?.onPlaneDetected()
            }
        }
    }
    var programEditor: ProgramEditorProtocol!
    
    //MARK: - Sound
    var audioController: AudioController? {
        didSet {
            winSound = audioController?.makeSound(withName: "win.wav")
            pickupSound = audioController?.makeSound(withName: "pickup.wav")
        }
    }
    private var winSound: AVAudioPlayer?
    private var pickupSound: AVAudioPlayer?
    
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
        if let player = levelViewModel?.player {
            programEditor.main.run(on: player)
        }
    }
    
    @IBAction func resetLevel(_ sender: UIButton) {
        levelViewModel?.levelModel?.reset() //TODO: Handle level reset by reloading level
        onLevelChanged()
    }
    
    @IBAction func placePlane(_ sender: UIButton) {
        if let levelViewModel = levelViewModel {
            planeViewModel.placeLevel(levelViewModel)
        }
    }
    
    private func onPlaneDetected() {
        placeButton.isHidden = false
        planePlacementHint.isHidden = false
        planeDetectionHint.isHidden = true
        planeDetectionAnimation.isHidden = true
        planeDetectionAnimation.stopAnimating()
    }
    
    private func onLevelChanged() {
        programEditor?.main.delegate = nil
        programEditor.reset()
        
        let info = self.levelViewModel?.levelModel?.infoLabel
        levelInfo.text = info
        winDescription.isHidden = true
        winLabel.isHidden = true
        executeButton.isHidden = true
        resetButton.isHidden = true
        
        if levelViewModel?.isAnchored ?? false {
            detectButton.isHidden = false
        }
    }
    
    private func onLevelPlaced() {
        detectButton.isHidden = false
        placeButton.isHidden = true
        planePlacementHint.isHidden = true
        levelInfo.text = levelViewModel?.levelModel?.infoLabel
    }
}

// MARK: - ProgramDelegate
extension LevelViewController: ProgramDelegate {
    func programBegan(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.executeButton.isEnabled = false
            self?.resetButton.isEnabled = false
        }
    }
    
    //TODO: A method for when we are about to execute a card so that we can highlight it
    func program(_ program: ProgramProtocol, executed card: Card) {
        
    }
    
    func programEnded(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.executeButton.isEnabled = true
            self?.resetButton.isEnabled = true
        }
    }
}

// MARK: - LevelDelegate
extension LevelViewController: LevelDelegate {
    
    func levelCompleted(_ level: LevelProtocol) {
        self.winSound?.play()
        
        DispatchQueue.main.async { [weak self] in
            self?.winLabel.isHidden = false
            self?.winDescription.isHidden = false
        }
    }
    
    func levelReset(_ level: LevelProtocol) {
        DispatchQueue.main.async { [weak self] in
            self?.winLabel.isHidden = true
            self?.winDescription.isHidden = true
        }
    }
    
    func levelInfoChanged(_ level: LevelProtocol, info: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.levelInfo.text = info
        }
    }
}
