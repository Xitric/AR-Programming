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
    var programEditor: ProgramEditorProtocol!
    
    //TODO
    var dropDelegate: ProgramDropInteractionDelegate!
    @IBOutlet weak var programWindow: UIView! {
        didSet {
            programWindow.addInteraction(UIDropInteraction(delegate: dropDelegate))
        }
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
//    @IBAction func detectCards(_ sender: UIButton) {
//        programEditor?.saveProgram()
//        programEditor?.main.delegate = self
//
//        executeButton.isHidden = false
//        resetButton.isHidden = false
//    }
    
//    @IBAction func executeSequence(_ sender: UIButton) {
//        if let player = levelViewModel?.player {
//            programEditor.main.run(on: player)
//        }
//    }
    
//    @IBAction func resetLevel(_ sender: UIButton) {
//        levelViewModel?.levelModel?.reset() //TODO: Handle level reset by reloading level
//        onLevelChanged()
//    }
    
    private func onLevelChanged() {
        programEditor?.main.delegate = nil
        programEditor.reset()
        
        levelViewModel?.levelModel?.delegate = self
        let info = self.levelViewModel?.levelModel?.infoLabel
        levelInfo.text = info
    }
}

// MARK: - ProgramDelegate
extension LevelViewController: ProgramDelegate {
    func programBegan(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
//            self?.executeButton.isEnabled = false
//            self?.resetButton.isEnabled = false
        }
    }
    
    //TODO: A method for when we are about to execute a card so that we can highlight it
    func program(_ program: ProgramProtocol, executed card: Card) {
        
    }
    
    func programEnded(_ program: ProgramProtocol) {
        DispatchQueue.main.async { [weak self] in
//            self?.executeButton.isEnabled = true
//            self?.resetButton.isEnabled = true
        }
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
