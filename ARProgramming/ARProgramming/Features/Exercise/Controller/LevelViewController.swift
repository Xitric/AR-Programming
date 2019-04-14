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
    var levelViewModel: LevelViewModeling? {
        didSet {
            //TODO: Can we move this responsibility elsewhere?
            //  Like always inject a new level object?
            levelViewModel?.reset()
            
            levelViewModel?.levelInfo.onValue = { [weak self] info in
                self?.levelInfo.text = info
            }
            
            levelViewModel?.complete.onValue = { [weak self] complete in
                if complete {
                    self?.winSound?.play()
                }
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
        levelViewModel?.reset()
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        if let player = levelViewModel?.player {
            programsViewModel.start(on: player)
        }
    }
}
