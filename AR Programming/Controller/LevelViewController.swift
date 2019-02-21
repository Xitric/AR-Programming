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
    @IBOutlet weak var planeDetectionLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winDescription: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var rectView: UIView!
    
    private var levelViewModel: LevelViewModel?
    
    //MARK: Sound
    private var winSound = AudioController.instance.makeSound(withName: "win.wav")
    private var pickupSound = AudioController.instance.makeSound(withName: "pickup.wav")
    
    //MARK: State
    var editor = ProgramEditor(screenWidth: Double(UIScreen.main.bounds.width),
                               screenHeight: Double(UIScreen.main.bounds.height))
    private var currentPlane: Plane? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.placeButton.isEnabled = self.currentPlane != nil
            }
        }
    }
    var level: Level? {
        didSet {
            program = nil
            playingField = nil
            winLabel.isHidden = true
            winDescription.isHidden = true
            level?.delegate = self
            editor.reset()
        }
    }
    
    private var playingField: PlayingField? {
        didSet {
            let hasPlayingField = playingField != nil
            
            placeButton.isHidden = hasPlayingField
            planeDetectionLabel.isHidden = hasPlayingField
            detectButton.isHidden = !hasPlayingField
            resetButton.isHidden = !hasPlayingField
            
            if let field = playingField {
                levelViewModel = LevelViewModel(showing: field, withLevelWidth: level!.width)
            }
        }
    }
    private var program: Program? {
        didSet {
            detectButton.isHidden = program != nil
            executeButton.isHidden = program == nil
        }
    }
    
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
    }
    
    // MARK: - UI Buttons
    @IBAction func startScanning(_ sender: UIButton) {
        if let parent = self.tabBarController as? HiddenTabBarViewController {
            parent.goToViewControllerWith(index: 1)
        }
    }
    
    @IBAction func detectCards(_ sender: UIButton) {
        program = editor.program
        program?.delegate = self
    }
    
    @IBAction func executeSequence(_ sender: UIButton) {
        if let robotModel = playingField?.robot.model {
            program?.run(on: robotModel)
            executeButton.isEnabled = false
            resetButton.isEnabled = false
        }
    }
    
    @IBAction func resetLevel(_ sender: UIButton) {
        level?.reset()
    }
    
    @IBAction func placePlane(_ sender: UIButton) {
        if let plane = currentPlane {
            showModelAt(detectedPlane: plane)
            showLevel()
            currentPlane = nil
        }
    }
    
    func showModelAt(detectedPlane plane: Plane) {
        if ((level?.delegate = self) != nil) {
            let robot = AnimatableNode(modelSource: "Meshes.scnassets/uglyBot.dae")
            robot.model.scale = SCNVector3(0.1, 0.1, 0.1)
            robot.model.position = SCNVector3(0, 0, 0)
            
            playingField = PlayingField(ground: plane, robot: robot)
        }
    }
    
    func showLevel() {
        if let currentLevel = level {
            for (x, y) in currentLevel.collectiblePositions {
                let sphereGeom = SCNSphere(radius: 0.01)
                let sphereNode = SCNNode(geometry: sphereGeom)
                
                levelViewModel?.addCollectible(node: sphereNode, x: x, y: y)
            }
        }
    }
}

// MARK: - GameplayController
extension LevelViewController: GameplayController {
    func enter(withLevel level: Level?, inEnvironment arController: ARController?) {
        arController?.planeDetectorDelegate = self
        arController?.frameDelegate = self
        
        if self.level != level {
            self.level = level
        }
    }
    
    func exit(withLevel level: Level?, inEnvironment arController: ARController?) {
        arController?.planeDetectorDelegate = nil
        arController?.frameDelegate = nil
    }
}

// MARK: - PlaneDetectorDelegate
extension LevelViewController: PlaneDetectorDelegate {
    func shouldDetectPlanes(_ detector: ARController) -> Bool {
        return playingField == nil
    }
    
    func planeDetector(_ detector: ARController, found plane: Plane) {
        currentPlane = plane
    }
}

// MARK: - FrameDelegate
extension LevelViewController: FrameDelegate {
    func frameScanner(_ scanner: ARController, didUpdate frame: CVPixelBuffer, withOrientation orientation: CGImagePropertyOrientation) {
        editor.newFrame(frame, oriented: orientation)
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
        
        for next in node.successors {
            drawNode(next)
        }
    }
}

// MARK: - ProgramDelegate
extension LevelViewController: ProgramDelegate {
    func programBegan(_ program: Program) {
        
    }
    
    func program(_ program: Program, executed card: Card) {
        if let currentLevel = level, let robot = playingField?.robot {
            let floatX = (robot.model.position.x / 0.05).rounded()
            let floatY = (robot.model.position.z / 0.05).rounded()
            currentLevel.notifyMovedTo(x: Int(floatX), y: Int(floatY))
        }
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
    func collectibleTaken(_ level: Level, x: Int, y: Int) {
        levelViewModel?.removeCollectible(x: x, y: y)
        self.pickupSound?.play()
    }
    
    func levelCompleted(_ level: Level) {
        self.winSound?.play()
        
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = false
            self.winDescription.isHidden = false
        }
    }
    
    func levelReset(_ level: Level) {
        playingField?.robot.model.position = SCNVector3(0, 0, 0)
        playingField?.robot.model.rotation = SCNVector4(0, 0, 0, 1)
        program = nil
        levelViewModel?.clearCollectibles()
        showLevel()
        
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = true
            self.winDescription.isHidden = true
        }
    }
}
