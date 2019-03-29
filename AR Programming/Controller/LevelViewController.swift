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
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var planeDetectionHint: SubtitleLabel!
    @IBOutlet weak var planePlacementHint: SubtitleLabel!
    @IBOutlet weak var levelInfo: SubtitleLabel!
    @IBOutlet weak var winDescription: SubtitleLabel!
    @IBOutlet weak var winLabel: UILabel!
    
    @IBOutlet weak var planeDetectionAnimation: UIImageView!
    @IBOutlet weak var rectView: UIView!
    
    //MARK: Sound
    private var winSound = AudioController.instance.makeSound(withName: "win.wav")
    private var pickupSound = AudioController.instance.makeSound(withName: "pickup.wav")
    
    //MARK: State
    private var editor = ProgramEditor()
    private var levelViewModel: LevelViewModel? {
        didSet {
            winLabel.isHidden = true
            winDescription.isHidden = true
            levelViewModel?.levelModel.delegate = self
            editor.reset()
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
        editor.delegate = self
        
        createPlaneAnimation()
    }
    
    private func createPlaneAnimation() {
        planeDetectionAnimation.animationImages = UIImage.loadAnimation(named: "ScanSurface", withFrames: 50)
        planeDetectionAnimation.animationDuration = 2.8
        planeDetectionAnimation.startAnimating()
    }
    
    // MARK: - Button actions
    @IBAction func startScanning(_ sender: UIButton) {
        if let parent = self.tabBarController as? HiddenTabBarViewController {
            parent.goToViewControllerWith(index: 1)
        }
    }
    
    @IBAction func detectCards(_ sender: UIButton) {
        editor.saveProgram()
        editor.main.delegate = self
        
//        detectButton.isHidden = true
        executeButton.isHidden = false
        resetButton.isHidden = false
    }
    
    @IBAction func executeSequence(_ sender: UIButton) {
        if let levelViewModel = levelViewModel {
            let player = levelViewModel.player
            editor.main.run(on: player)
        }
    }
    
    @IBAction func resetLevel(_ sender: UIButton) {
        levelViewModel?.levelModel.reset()
        editor.main.delegate = nil
        editor.reset()
        
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
    func enter(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?) {
        arController?.planeDetectorDelegate = self
        arController?.frameDelegate = self
        
        if self.levelViewModel?.levelModel.levelNumber != levelViewModel?.levelModel.levelNumber {
            self.levelViewModel = levelViewModel
            
            DispatchQueue.main.async { [unowned self] in
                let info = levelViewModel?.levelModel.infoLabel
                self.levelInfo.text = info
                self.levelInfo.isHidden = info == nil
            }
        }
    }
    
    func exit(withLevel levelViewModel: LevelViewModel?, inEnvironment arController: ARController?) {
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
        editor.newFrame(frame, oriented: orientation, frameWidth: Double(UIScreen.main.bounds.width), frameHeight: Double(UIScreen.main.bounds.height))
    }
}

// MARK: - ProgramEditorDelegate
extension LevelViewController: ProgramEditorDelegate {
    func programEditor(_ programEditor: ProgramEditor, createdNew program: Program) {
        for rect in rectView.subviews {
            rect.removeFromSuperview()
        }
        drawNode(program.start)
    }
    
    private func drawNode(_ node: CardNode?) {
        guard let node = node else {
            return
        }
        
        let rect = UIView(frame: CGRect(x: node.position.x - 48, y: Double(UIScreen.main.bounds.height) - node.position.y - 48, width: 96, height: 96))
        rect.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 1, alpha: 0.5)
        rectView.addSubview(rect)
        
        for next in node.children {
            drawNode(next)
        }
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
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = true
            self.winDescription.isHidden = true
        }
    }
    
    func levelInfoChanged(_ level: Level, info: String?) {
        DispatchQueue.main.async { [unowned self] in
            self.levelInfo.text = info
            self.levelInfo.isHidden = info == nil
        }
    }
}
