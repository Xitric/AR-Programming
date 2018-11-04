//
//  PlayViewController.swift
//  AR Programming
//
//  Created by user143563 on 10/15/18.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlayViewController: UIViewController, CardDetectorDelegate, PlaneDetectorDelegate {
    
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView! {
        didSet {
            arCardFinder = PlayConfiguration(with: sceneView, for: "Cards")
            arCardFinder?.cardDetectorDelegate = self
            arCardFinder?.planeDetectorDelegate = self
        }
    }
    @IBOutlet weak var planeDetectionLabel: UILabel!
    @IBOutlet weak var detectBtn: UIButton!
    
    var level: Level? {
        didSet {
            arCardFinder?.cardMapper = level
        }
    }
    private var detectPlane: Bool = false {
        didSet {
            planeDetectionLabel.isHidden = !detectPlane
            detectBtn.isEnabled = !detectPlane
            detectBtn.isHidden = detectPlane
            placeBtn.isEnabled = detectPlane
            placeBtn.isHidden = !detectPlane
        }
    }
    private var playingField: PlayingField? //TODO: Can we do something about this?
    private var currentPlane: Plane? //TODO: Can we do something about this?
    private var arCardFinder: PlayConfiguration?
    private var cardSequence : CardSequence?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: For debugging
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arCardFinder?.start()
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arCardFinder?.stop()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func detectPlane(_ sender: UIButton) {
        detectPlane = true
        
        //Remove current plane
        if let field = playingField {
            sceneView.session.remove(anchor: field.origo.anchor)
            currentPlane = nil
        }
    }
    
    @IBAction func placeObjectOnPlane(_ sender: UIButton) {
        detectPlane = false
        if let plane = currentPlane {
            showModelAtDetectedPlane(plane: plane)
        }
        //currentPlane?.node.removeFromParentNode()
    }
    
    @IBAction func execute(_ sender: Any) {
        cardSequence?.run(on: playingField!.robot)
    }
    
    @IBAction func reset(_ sender: Any) {
        playingField?.robot.model.position = SCNVector3(0, 0, 0)
        playingField?.robot.model.rotation = SCNVector4(0, 0, 0, 1)
    }
    
    func showModelAtDetectedPlane(plane: Plane) {
        let origo = AnchoredNode(anchor: plane.anchor, node: plane.node.parent!)
        
        let robot = AnimatableNode(modelSource: "Meshes.scnassets/uglyBot.dae")
        robot.model.scale = SCNVector3(0.1, 0.1, 0.1)
        robot.model.position = SCNVector3(0, 0, 0)
        
        playingField = PlayingField(origo: origo, ground: plane, robot: robot)
        
        origo.node.addChildNode(robot.model)
    }
    
    func cardDetector(_ detector: CardDetector, found card: Card) {
        recreateCardSequence()
    }
    
    func cardDetector(_ detector: CardDetector, lost card: Card) {
        recreateCardSequence()
    }
    
    private func recreateCardSequence() {
        if let field = playingField {
            cardSequence = CardSequence(cards: arCardFinder!.cardWorld, on: field.ground)
        }
    }
    
    func shouldDetectPlanes(_ detector: PlaneDetector) -> Bool {
        return detectPlane
    }
    
    func planeDetector(_ detector: PlaneDetector, found plane: Plane) {
        currentPlane = plane
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scan" {
            if let scanner = segue.destination as? ScanViewController {
                scanner.level = level;
            }
        }
    }
    
    @IBAction func unwindToPlayView(segue: UIStoryboardSegue) {
        if let levelSelector = segue.source as? LevelSelectViewController {
            level = levelSelector.selectedLevel
        }
    }
}
