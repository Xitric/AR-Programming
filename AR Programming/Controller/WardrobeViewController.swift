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
            setRobot(daeFile: robotFiles[robotChoice])
            sceneView.scene!.rootNode.addChildNode(cameraNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        robotFiles = getDaeFileNames()
    }
    
    override func viewDidLoad() {
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.white
        sceneView.autoenablesDefaultLighting = true
        
        cameraNode.name = "Camera"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 5)
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
    
    private func getDaeFileNames() -> [String] {
        var daeFiles: [String] = []
        
        if let path = Bundle.main.resourcePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: path + "/Meshes.scnassets")
                
                for name in files {
                    if name.hasSuffix(".dae") {
                        daeFiles.append(name)
                    }
                }
                print(daeFiles.count)
                print(daeFiles)
            } catch let error as NSError {
                print(error.description)
            }
        }
        return daeFiles
    }
}
