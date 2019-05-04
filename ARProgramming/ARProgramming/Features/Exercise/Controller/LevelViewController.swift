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

class LevelViewController: UIViewController, InteractiveProgramDelegate {
    
    //MARK: - View
    @IBOutlet weak var levelInfo: SubtitleLabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var programScrollView: UIScrollView! {
        didSet {
            programScrollView.addInteraction(UIDropInteraction(delegate: dropDelegate))
        }
    }
    @IBOutlet weak var programView: InteractiveProgramView! {
        didSet {
            programView.viewModel = programsViewModel
            programView.delegate = self
        }
    }
    @IBOutlet weak var exerciseCompletionView: UIView!
    
    //MARK: - Observers
    private var levelObserver: Observer?
    private var infoObserver: Observer?
    private var completeObserver: Observer?
    private var runningObserver: Observer?
    private var executedCardsObserver: Observer?
    private var droppedProgramObserver: Observer?
    
    //MARK: - Injected properties
    var viewModel: LevelViewModeling! {
        didSet {
            levelObserver = viewModel.level.observeFuture { [weak self] level in
                self?.resetButton.isEnabled = true
                self?.playButton.isEnabled = true
                self?.programView.isUserInteractionEnabled = true
                self?.programsViewModel.reset()
            }
            
            completeObserver = viewModel.complete.observeFuture { [weak self] complete in
                if complete {
                    self?.winSound?.play()
                }
                
                self?.exerciseCompletionView.isHidden = !complete
            }
        }
    }
    var programsViewModel: ProgramsViewModeling! {
        didSet {
            runningObserver = programsViewModel.running.observeFuture { [weak self] running in
                self?.playButton.isEnabled = !running
                self?.programView.isUserInteractionEnabled = !running
            }
            
            executedCardsObserver = programsViewModel.executedCards.observeFuture { [weak self] cardCount in
                self?.viewModel.scoreUpdated(newScore: cardCount)
            }
        }
    }
    var dropDelegate: ProgramDropInteractionDelegate! {
        didSet {
            droppedProgramObserver = dropDelegate.droppedProgram.observeFuture { [weak self] program in
                if let program = program {
                    self?.programsViewModel.add(program: program)
                }
            }
        }
    }
    
    deinit {
        programsViewModel.reset()
        
        levelObserver?.release()
        infoObserver?.release()
        completeObserver?.release()
        runningObserver?.release()
        executedCardsObserver?.release()
        droppedProgramObserver?.release()
    }
    
    //MARK: - Sound
    var audioController: AudioController! {
        didSet {
            winSound = audioController.makeSound(withName: "Sounds/win.wav")
            pickupSound = audioController.makeSound(withName: "Sounds/pickup.wav")
        }
    }
    private var winSound: AVAudioPlayer?
    private var pickupSound: AVAudioPlayer?
    
    // MARK: - Functionality
    override func viewWillAppear(_ animated: Bool) {
        infoObserver = viewModel.levelInfo.observe { [weak self] info in
            self?.levelInfo.text = info
            self?.levelInfo.isHidden = (info == nil)
        }
    }
    
    @IBAction func onReset(_ sender: UIButton) {
        programsViewModel.reset()
        viewModel.reset()
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        if let player = viewModel.player {
            programsViewModel.start(on: player)
        }
    }
    
    // MARK: - InteractiveProgramDelegate
    func interactiveProgram(_ view: InteractiveProgramView, pressed program: ProgramProtocol) {
        if let player = viewModel.player {
            programsViewModel.start(on: player)
        }
    }
}
