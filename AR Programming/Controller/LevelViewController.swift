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
import AudioKit

class LevelViewController: UIViewController {
    
    //MARK: View
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var detectButton: UIButton!
    @IBOutlet weak var executeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var planeDetectionHint: SubtitleLabel!
    @IBOutlet weak var planePlacementHint: SubtitleLabel!
    @IBOutlet weak var winDescription: SubtitleLabel!
    @IBOutlet weak var winLabel: UILabel!
    
    @IBOutlet weak var planeDetectionAnimation: UIImageView!
    @IBOutlet weak var rectView: UIView!
    
    //MARK: Sound
    private var winSound = AudioController.instance.makeSound(withName: "win.wav")
    private var pickupSound = AudioController.instance.makeSound(withName: "pickup.wav")

    
    //MARK: State
    var programEditor: ProgramEditor?
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioController.instance.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioController.instance.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        createPlaneAnimation()
//        let cardRect = CardRect(frame:  CGRect(x: 100, y: 100, width: 96, height: 96))
//        view.addSubview(cardRect)
//
        
    }
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        print("viewTapped  CALLED")
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    private func createPlaneAnimation() {
        planeDetectionAnimation.animationImages = UIImage.loadAnimation(named: "ScanSurface", withFrames: 50)
        planeDetectionAnimation.animationDuration = 2.8
        planeDetectionAnimation.startAnimating()
     
    }
    
    // MARK: - Button actions    
    @IBAction func detectCards(_ sender: UIButton) {
        programEditor?.saveProgram()
        programEditor?.program.delegate = self
        
        detectButton.isHidden = true
        executeButton.isHidden = false
        resetButton.isHidden = false
    }
    
    @IBAction func executeSequence(_ sender: UIButton) {
        if let levelViewModel = levelViewModel {
            let player = levelViewModel.player
            programEditor?.program.run(on: player)
        }
    }
    
    @IBAction func resetLevel(_ sender: UIButton) {
        levelViewModel?.levelModel.reset()
        programEditor?.program.delegate = nil
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
    func enter(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?, withEditor programEditor: ProgramEditor?) {
        arController?.planeDetectorDelegate = self
        arController?.frameDelegate = self
        self.programEditor = programEditor
        if self.levelViewModel?.levelModel.levelNumber != levelViewModel?.levelModel.levelNumber {
            self.levelViewModel = levelViewModel
        }
    }

    func exit(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?, withEditor programEditor: ProgramEditor?) {
        arController?.planeDetectorDelegate = nil
        arController?.frameDelegate = nil
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

// MARK: - FrameDelegate
extension LevelViewController: FrameDelegate {
    func frameScanner(_ scanner: ARController, didUpdate frame: CVPixelBuffer, withOrientation orientation: CGImagePropertyOrientation) {
        programEditor?.newFrame(frame, oriented: orientation, frameWidth: Double(UIScreen.main.bounds.width), frameHeight: Double(UIScreen.main.bounds.height))
    }
}



// MARK: - ProgramDelegate
extension LevelViewController: ProgramDelegate {
    func programBegan(_ program: Program) {
        DispatchQueue.main.async { [unowned self] in
            self.executeButton.isEnabled = false
            self.resetButton.isEnabled = false
        }
    }
    
    //TODO: A method for when we are about to execute a card so that we can highlight it
    func program(_ program: Program, executed card: Card) {
        
    }
    
    func programEnded(_ program: Program) {
        DispatchQueue.main.async { [unowned self] in
            self.executeButton.isEnabled = true
            self.resetButton.isEnabled = true
        }
    }
}

// MARK: - LevelDelegate
extension LevelViewController: LevelDelegate {
    func levelCompleted(_ level: Level) {
        self.winSound?.play()
        
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = false
            self.winDescription.isHidden = false
        }
    }
    
    func levelReset(_ level: Level) {
        //TODO: What needs to go here?
        //TODO: Probably some refreshing of labels
        
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = true
            self.winDescription.isHidden = true
        }
    }
}
