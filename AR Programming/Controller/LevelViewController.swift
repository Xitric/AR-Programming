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

class LevelViewController: UIViewController, PlaneDetectorDelegate, CardSequenceProgressDelegate {
    
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var detectButton: UIButton!
    @IBOutlet weak var executeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var planeDetectionLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winDescription: UILabel!
    
    //MARK: Sound
    var winSound = AudioController.instance.makeSound(withName: "win.wav")
    
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
            cardSequence = nil
            playingField = nil
            winLabel.isHidden = true
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
        }
    }
    private var cardSequence : CardSequence? {
        didSet {
            detectButton.isHidden = cardSequence != nil
            executeButton.isHidden = cardSequence == nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AudioController.instance.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AudioController.instance.stop()
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
        let origo = AnchoredNode(anchor: plane.anchor, node: plane.node.parent!)

        let robot = AnimatableNode(modelSource: "Meshes.scnassets/uglyBot.dae")
        robot.model.scale = SCNVector3(0.1, 0.1, 0.1)
        robot.model.position = SCNVector3(0, 0, 0)

        playingField = PlayingField(origo: origo, ground: plane, robot: robot, collectibles: [SCNNode]())

        origo.node.addChildNode(robot.model)
    }

    func showLevel() {
        if let currentLevel = level {
            for collectible in currentLevel.tiles.collectiblePositions {
                let sphereGeom = SCNSphere(radius: 0.01)
                let sphereNode = SCNNode(geometry: sphereGeom)

                sphereNode.position = SCNVector3(collectible.x * 0.05, 0, collectible.y * 0.05)
                playingField?.addCollectible(node: sphereNode)
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
    }
    
    @IBAction func resetLevel(_ sender: UIButton) {
        playingField?.robot.model.position = SCNVector3(0, 0, 0)
        playingField?.robot.model.rotation = SCNVector4(0, 0, 0, 1)
        cardSequence = nil
        level?.reset()
        winLabel.isHidden = true
        winDescription.isHidden = true
        playingField?.clearCollectibles()
        showLevel()
    }
    
    func cardSequence(robot: AnimatableNode, executed card: Card) {
        if let currentLevel = level {
            let floatX = (robot.model.position.x / 0.05).rounded()
            let floatY = (robot.model.position.z / 0.05).rounded()
            currentLevel.notifyMovedTo(x: Int(floatX), y: Int(floatY))
            
            DispatchQueue.main.async { [unowned self] in
                self.playingField?.removeCollectible(at: Vector2(x: robot.model.position.x, y: robot.model.position.z))
                
                if currentLevel.isComplete {
                    self.levelComplete()
                }
            }
        }
    }
    
    private func removeNodeAt() {
        
    }
    
    private func levelComplete() {
        winSound?.start()
        winLabel.isHidden = false
        winDescription.isHidden = false
    }
}
