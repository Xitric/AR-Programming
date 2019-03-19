//
//  WardrobeViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 15/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class WardrobeViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    private let cameraNode = SCNNode()
    private var robotChoice = 0;
    private var robotFiles: [String] = [] {
        didSet {
            robotChoice = robotFiles.firstIndex(of: WardrobeManager.robotChoice())!
            setRobot(daeFile: robotFiles[robotChoice])
            sceneView.scene!.rootNode.addChildNode(cameraNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        robotFiles = WardrobeManager.getDaeFileNames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.white
        sceneView.autoenablesDefaultLighting = true
        
        cameraNode.name = "Camera"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WardrobeManager.setRobotChoice(choice: robotFiles[robotChoice])
    }
    
    
    @IBAction func nextRobot(_ sender: UIButton) {
        if robotChoice == robotFiles.count-1 {
            robotChoice = 0
        } else {
            robotChoice+=1
        }
        setRobot(daeFile: robotFiles[robotChoice])
    }
    
    @IBAction func previousRobot(_ sender: UIButton) {
        if robotChoice == 0 {
            robotChoice = robotFiles.count-1
        } else {
            robotChoice-=1
        }
        setRobot(daeFile: robotFiles[robotChoice])
    }
    
    private func setRobot(daeFile: String) {
        let scene = SCNScene(named: "Meshes.scnassets/" + daeFile)
        scene?.rootNode.rotation = SCNVector4(0, -1, 0, 1)
        sceneView.scene = scene
    }
}
