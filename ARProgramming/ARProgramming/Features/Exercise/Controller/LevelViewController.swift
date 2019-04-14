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
    @IBOutlet weak var levelInfo: SubtitleLabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var programScrollView: UIScrollView! {
        didSet {
            programScrollView.addInteraction(UIDropInteraction(delegate: dropDelegate))
        }
    }
    @IBOutlet weak var programView: ProgramView! {
        didSet {
            programView.programsViewModel = programsViewModel
        }
    }
    
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
        }
    }
    var programsViewModel: ProgramsViewModeling! {
        didSet {
            programsViewModel.running.onValue = { [weak self] running in
                self?.resetButton.isEnabled = !running
                self?.playButton.isEnabled = !running
            }
        }
    }
    var dropDelegate: ProgramDropInteractionDelegate! {
        didSet {
            dropDelegate.droppedProgram.onValue = { [weak self] program in
                if let program = program {
                    self?.programsViewModel.add(program: program)
                }
            }
        }
    }
    
    deinit {
        programsViewModel.reset()
    }
    
    //MARK: - Sound
    var audioController: AudioController? {
        didSet {
            winSound = audioController?.makeSound(withName: "win.wav")
            pickupSound = audioController?.makeSound(withName: "pickup.wav")
        }
    }
    private var winSound: AVAudioPlayer?
    private var pickupSound: AVAudioPlayer?
    
    // MARK: - Button actions
    @IBAction func onReset(_ sender: UIButton) {
        programsViewModel.reset()
        levelViewModel?.levelModel?.reset() //TODO: Handle level reset by reloading level
        onLevelChanged()
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        if let player = levelViewModel?.player {
            programsViewModel.start(on: player)
        }
    }
    
    private func onLevelChanged() {
//        programEditor?.main.delegate = nil
//        programEditor.reset()
        
        levelViewModel?.levelModel?.delegate = self
        let info = self.levelViewModel?.levelModel?.infoLabel
        levelInfo.text = info
    }
}

// MARK: - LevelDelegate
extension LevelViewController: LevelDelegate {
    
    func levelCompleted(_ level: LevelProtocol) {
        self.winSound?.play()
        
        DispatchQueue.main.async { [weak self] in
//            self?.winLabel.isHidden = false
//            self?.winDescription.isHidden = false
        }
    }
    
    func levelReset(_ level: LevelProtocol) {
        DispatchQueue.main.async { [weak self] in
//            self?.winLabel.isHidden = true
//            self?.winDescription.isHidden = true
        }
    }
    
    func levelInfoChanged(_ level: LevelProtocol, info: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.levelInfo.text = info
        }
    }
}
