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
    var robotNode: SCNNode?
    var robot: AnimatableNode?
    private var currentPlane: Plane?
    private var environment: PlayConfiguration?
    
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView! {
        didSet {
            environment = PlayConfiguration(with: sceneView)
            environment?.cardDetectorDelegate = self
            environment?.planeDetectorDelegate = self
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
    
    @IBAction func testMoveRobot(_ sender: UIButton) {
        //robot?.move(by: SCNVector3(1,0,0))
        robot?.jump(by: 0.1, in: 0.3)
    }
    
    @IBAction func detectPlane(_ sender: UIButton) {
        detectPlane = true
        placeBtn.isEnabled = true
        placeBtn.isHidden = false
        detectBtn.isEnabled = false
        detectBtn.isHidden = true
    }
    
    @IBAction func placeObjectOnPlane(_ sender: UIButton) {
        detectPlane = false
        currentPlane?.planeNode.removeFromParentNode()
        if let plane = currentPlane {
            showModelAtDetectedPlane(plane: plane)
        }
        detectBtn.isEnabled = true
        detectBtn.isHidden = false
        placeBtn.isEnabled = false
        placeBtn.isHidden = true
    }
    
    func showModelAtDetectedPlane(plane: Plane) {
        robot = AnimatableNode(modelSource: "Meshes.scnassets/uglyBot.dae")
        robot!.model.scale = SCNVector3(0.1, 0.1, 0.1)
        let node = robot!.model
        node.position = SCNVector3(0, 0, 0)
        
        let parent = sceneView.node(for: plane.anchor)
        parent?.addChildNode(node)
    }
    
    func cardDetector(_ detector: CardDetector, found cardName: String) {
        
    }
    
    func cardDetector(_ detector: CardDetector, lost cardName: String) {
        
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
