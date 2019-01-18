//
//  LevelViewController.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 12/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import AudioKit

class LevelViewController: UIViewController, PlaneDetectorDelegate, CardSequenceProgressDelegate, LevelDelegate {
    
    //MARK: View
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var detectButton: UIButton!
    @IBOutlet weak var executeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var planeDetectionLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winDescription: UILabel!
    
    private var levelViewModel: LevelViewModel?
    
    //MARK: Sound
    private var winSound = AudioController.instance.makeSound(withName: "win.wav")
    private var pickupSound = AudioController.instance.makeSound(withName: "pickup.wav")
    
    //MARK: State
    var arController: ARController?
    private var currentPlane: Plane? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.placeButton.isEnabled = self.currentPlane != nil
            }
        }
    }
    var level: Level? {
        didSet {
            placeButton.isEnabled = true
            placeButton.isHidden = false
            cardSequence = nil
            playingField = nil
            winLabel.isHidden = true
            winDescription.isHidden = true
            level?.delegate = self
        }
    }
    private var playingField: PlayingField? {
        didSet {
            let hasPlayingField = playingField != nil
            
            placeButton.isHidden = hasPlayingField
            planeDetectionLabel.isHidden = hasPlayingField
            detectButton.isHidden = !hasPlayingField
            executeButton.isHidden = !hasPlayingField
            resetButton.isHidden = !hasPlayingField
            
            if let field = playingField {
                levelViewModel = LevelViewModel(showing: field, withLevelWidth: level!.width)
            }
        }
    }
    private var cardSequence : CardSequence? {
        didSet {
            detectButton.isHidden = cardSequence != nil
            executeButton.isHidden = cardSequence == nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioController.instance.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioController.instance.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeButton.isEnabled = false
        placeButton.isHidden = true
    }
    
    func shouldDetectPlanes(_ detector: ARController) -> Bool {
        return playingField == nil
    }
    
    func planeDetector(_ detector: ARController, found plane: Plane) {
        currentPlane = plane
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
            let origo = AnchoredNode(anchor: plane.anchor, node: plane.node.parent!)

            let robot = AnimatableNode(modelSource: "Meshes.scnassets/uglyBot.dae")
            robot.model.scale = SCNVector3(0.1, 0.1, 0.1)
            robot.model.position = SCNVector3(0, 0, 0)

            playingField = PlayingField(origo: origo, ground: plane, robot: robot)

            origo.node.addChildNode(robot.model)
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
    
    @IBAction func detectCards(_ sender: UIButton) {
        if let field = playingField {
            cardSequence = CardSequence(cards: arController!.cardWorld, on: field.ground)
            cardSequence?.delegate = self
        }
    }
    
    @IBAction func executeSequence(_ sender: UIButton) {
        cardSequence?.run(on: playingField!.robot)
        executeButton.isEnabled = false
        resetButton.isEnabled = false
    }
    
    @IBAction func resetLevel(_ sender: UIButton) {
        level?.reset()
    }
    
    func cardSequence(robot: AnimatableNode, executed card: Card) {
        if let currentLevel = level {
            let floatX = (robot.model.position.x / 0.05).rounded()
            let floatY = (robot.model.position.z / 0.05).rounded()
            currentLevel.notifyMovedTo(x: Int(floatX), y: Int(floatY))
        }
    }
    
    func cardSequenceFinished(robot: AnimatableNode) {
        DispatchQueue.main.async { [unowned self] in
            self.executeButton.isEnabled = true
            self.resetButton.isEnabled = true
        }
    }
    
    func collectibleTaken(_ level: Level, x: Int, y: Int) {
        levelViewModel?.removeCollectible(x: x, y: y)
        self.pickupSound?.start()
    }
    
    func levelCompleted(_ level: Level) {
        self.winSound?.start()
        
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = false
            self.winDescription.isHidden = false
        }
    }
    
    func levelReset(_ level: Level) {
        playingField?.robot.model.position = SCNVector3(0, 0, 0)
        playingField?.robot.model.rotation = SCNVector4(0, 0, 0, 1)
        cardSequence = nil
        levelViewModel?.clearCollectibles()
        showLevel()
        
        DispatchQueue.main.async { [unowned self] in
            self.winLabel.isHidden = true
            self.winDescription.isHidden = true
        }
    }
}
