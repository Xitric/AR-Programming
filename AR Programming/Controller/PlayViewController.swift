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
            
            //TODO: Temporary
            arCardFinder?.cardMapper = Level(cards:[
                1: Card(name: "Start", description: "Use the Start card to indicate where the program starts. Whenever the program is executed, it will begin at this card.", type: CardType.control, command: nil),
                2: Card(name: "Jump", description: "Use the Jump card to make the robot jump in place.", type: CardType.action, command: JumpCommand())])
        }
    }
    @IBOutlet weak var planeDetectionLabel: UILabel!
    @IBOutlet weak var detectBtn: UIButton!
    
    private var detectPlane: Bool = false {
        didSet {
            planeDetectionLabel.isHidden = !detectPlane
            detectBtn.isEnabled = !detectPlane
            detectBtn.isHidden = detectPlane
            placeBtn.isEnabled = detectPlane
            placeBtn.isEnabled = !detectPlane
        }
    }
    private var playingField: PlayingField? //TODO: Can we do something about this?
    private var currentPlane: Plane? //TODO: Can we do something about this?
    private var arCardFinder: PlayConfiguration?
    
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
        currentPlane?.node.removeFromParentNode()
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
        for c in arCardFinder!.cardWorld.allCards() {
            print(c.name)
        }
    }
    
    func cardDetector(_ detector: CardDetector, lost card: Card) {
        
    }
    
    func shouldDetectPlanes(_ detector: PlaneDetector) -> Bool {
        return detectPlane
    }
    
    func planeDetector(_ detector: PlaneDetector, found plane: Plane) {
        currentPlane = plane
    }
    
    //TODO: Card projection logic - very important!
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
}
