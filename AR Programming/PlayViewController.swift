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

class PlayViewController: UIViewController, ARSCNViewDelegate {
    
    var currentPlane: SCNNode?
    var detectPlane: Bool = false;
    var boxNode: SCNNode?
    
    @IBOutlet weak var detectBtn: UIButton!
    @IBOutlet weak var placeBtn: UIButton!
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeBtn.isEnabled = false
        placeBtn.isHidden = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // For debugging
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: nil)
        // Detect horizontal planes
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if (detectPlane){
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            if let plane = currentPlane {
                if let currentAnchor = sceneView.anchor(for: plane){
                    sceneView.session.remove(anchor: (currentAnchor))
                }
                node.addChildNode(plane)
            } else {
                let plane = Plane(anchor: planeAnchor)
                plane.planeGeometry.materials.first?.diffuse.contents = UIImage(named: "tron_grid")
                currentPlane = plane.planeNode
                node.addChildNode(currentPlane!)
            }
            boxNode?.removeFromParentNode()
            boxNode = showModelAtDetectedPlane()
            node.addChildNode(boxNode!)
        }
    }
    
    func showModelAtDetectedPlane() -> SCNNode{
        
        let box : SCNBox = SCNBox(width: 0.1,height: 0.1,length: 0.1,chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.purple
        
        // Wrap box in a node
        let node = SCNNode(geometry: box)
        node.position = SCNVector3Make(0, 0.05, 0)

        return node
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
        currentPlane?.removeFromParentNode()
        detectBtn.isEnabled = true
        detectBtn.isHidden = false
        placeBtn.isEnabled = false
        placeBtn.isHidden = true
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}
