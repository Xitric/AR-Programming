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
    
    private var detectPlane: Bool = false {
        didSet {
            planeDetectionLabel.isHidden = !detectPlane
        }
    }
    var playingField: PlayingField?
    private var currentPlane: Plane?
    private var environment: PlayConfiguration?
    //private var cardMapper: CardMapper?
    private var levelDatabase: LevelDatabase?
    
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView! {
        didSet {
            environment = PlayConfiguration(with: sceneView, with: CardWorld())
            environment?.cardDetectorDelegate = self
            environment?.planeDetectorDelegate = self
            levelDatabase = LevelDatabase()
            //cardMapper = levelDatabase?.levels[0]
        }
    }
    @IBOutlet weak var planeDetectionLabel: UILabel!
    @IBOutlet weak var detectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeBtn.isEnabled = false
        placeBtn.isHidden = true
        // For debugging
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        environment?.start()
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        environment?.stop()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func detectPlane(_ sender: UIButton) {
        detectPlane = true
        placeBtn.isEnabled = true
        placeBtn.isHidden = false
        detectBtn.isEnabled = false
        detectBtn.isHidden = true
        
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
        currentPlane?.node.removeFromParentNode()
        detectBtn.isEnabled = true
        detectBtn.isHidden = false
        placeBtn.isEnabled = false
        placeBtn.isHidden = true
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
        
    }
    
    func cardDetector(_ detector: CardDetector, lost card: Card) {
        
    }
    
    func shouldDetectPlanes(_ detector: PlaneDetector) -> Bool {
        return detectPlane
    }
    
    func planeDetector(_ detector: PlaneDetector, found plane: Plane) {
        currentPlane = plane
    }
    
    //TODO: START
//    private var spheres = [SCNNode]()
//    
//    func cardDetector(_ detector: CardDetector, added cardName: String) {
//        if let plane = currentPlane {
//            for sphere in spheres {
//                sphere.removeFromParentNode()
//            }
//            
//            for cardPlane in (cardDetector?.cardPlanes)! {
//                let center = cardPlane.center
//                let projection = plane.project(point: center)
//                
//                let sphereGeometry = SCNSphere(radius: 0.005)
//                let sphere = SCNNode(geometry: sphereGeometry)
//                sphere.position = SCNVector3(projection.x, projection.y, 0)
//                plane.planeNode.addChildNode(sphere)
//                spheres.append(sphere)
//            }
//        }
//    }
//    
//    func cardDetector(_ detector: CardDetector, removed cardName: String) {
//        
//    }
//    
//    func cardDetector(_ detector: CardDetector, scanned cardName: String) {
//        
//    }
//    
//    func cardDetectorLostCard(_ detector: CardDetector) {
//        
//    }
}
