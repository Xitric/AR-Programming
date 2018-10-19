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

class PlayViewController: UIViewController, ARSCNViewDelegate, CardDetectorDelegate {
    
//    var currentPlane: Plane?
    var detectPlane: Bool = false {
        didSet {
            planeDetectionLabel.isHidden = !detectPlane
        }
    }
//    var boxNode: SCNNode?
    private var environment: PlayEnvironment?
    private var cardDetector: CardDetector? {
        didSet {
            cardDetector?.delegate = self
        }
    }
    
    @IBOutlet var sceneView: ARSCNView! {
        didSet {
            cardDetector = CardDetector(with: sceneView)
            environment = PlayEnvironment(sceneView: sceneView)
            environment?.add(scnDelegate: self)
            environment?.add(scnDelegate: cardDetector!)
            environment?.add(sessDelegate: cardDetector!)
        }
    }
    @IBOutlet weak var planeDetectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        if (detectPlane){
//            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//
//            if let plane = currentPlane {
//                if let currentAnchor = sceneView.anchor(for: plane.planeNode){
//                    sceneView.session.remove(anchor: (currentAnchor))
//                }
//                node.addChildNode(plane.planeNode)
//            } else {
//                let plane = Plane(width: 0.2, height: 0.2, anchor: anchor)
//                plane.planeGeometry.materials.first?.diffuse.contents = UIImage(named: "tron_grid")
//                currentPlane = plane
//                node.addChildNode(currentPlane!.planeNode)
//            }
////            node.addChildNode(showModelAtDetectedPlane())
//        }
//    }
//
//    func showModelAtDetectedPlane() -> SCNNode{
//
//        let box : SCNBox = SCNBox(width: 0.1,height: 0.1,length: 0.1,chamferRadius: 0)
//
//        box.firstMaterial?.diffuse.contents = UIColor.purple
//
//        // Wrap box in a node
//        boxNode = SCNNode(geometry: box)
//
//        boxNode?.position = SCNVector3Make(0, 0.05, 0)
//
//        return boxNode!
//    }
    
    @IBAction func detectPlane(_ sender: UIButton) {
        detectPlane = true
    }
    
    @IBAction func placeObjectOnPlane(_ sender: UIButton) {
//        currentPlane?.plan$eNode.removeFromParentNode()
       
        detectPlane = false
    }
    
    //TODO: START
    private var spheres = [SCNNode]()
    
    func cardDetector(_ detector: CardDetector, added cardName: String) {
        if let plane = currentPlane {
            for sphere in spheres {
                sphere.removeFromParentNode()
            }
            
            for cardPlane in (cardDetector?.cardPlanes)! {
                let center = cardPlane.center
                let projection = plane.project(point: center)
                
//                print("---------")
//                print(center)
//                print(projection)
//                print(plane.planeNode.position)
                
                let sphereGeometry = SCNSphere(radius: 0.005)
                let sphere = SCNNode(geometry: sphereGeometry)
                sphere.position = SCNVector3(projection.x, projection.y, 0)
//                sphere.position = center
                plane.planeNode.addChildNode(sphere)
//                sceneView.scene.rootNode.addChildNode(sphere)
                spheres.append(sphere)
            }
        }
    }
    
    func cardDetector(_ detector: CardDetector, removed cardName: String) {
        
    }
    
    func cardDetector(_ detector: CardDetector, scanned cardName: String) {
        
    }
    
    func cardDetectorLostCard(_ detector: CardDetector) {
        
    }
}
