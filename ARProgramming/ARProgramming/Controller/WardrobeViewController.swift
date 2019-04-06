//
//  WardrobeViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 15/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import SceneKit

class WardrobeViewController: UIViewController {
    
    @IBOutlet weak var robotChoiceLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    private var robotChoice = 0 {
        didSet {
            updateChoiceLabel()
        }
    }
    private var robotCount = 0 {
        didSet {
            updateChoiceLabel()
        }
    }
    
    private var robotFiles: [String] = [] {
        didSet {
            robotChoice = robotFiles.firstIndex(of: WardrobeManager.robotChoice()) ?? 0
            robotCount = robotFiles.count
            setRobot(daeFile: robotFiles[robotChoice])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        robotFiles = WardrobeManager.getFileNames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WardrobeManager.setRobotChoice(choice: robotFiles[robotChoice])
    }
    
    @IBAction func nextRobot(_ sender: UIButton) {
        robotChoice = (robotChoice + 1) % robotFiles.count
        setRobot(daeFile: robotFiles[robotChoice])
    }
    
    @IBAction func previousRobot(_ sender: UIButton) {
        robotChoice = (robotChoice - 1 + robotFiles.count) % robotFiles.count
        setRobot(daeFile: robotFiles[robotChoice])
    }
    
    private func setRobot(daeFile: String) {
        let scene = SCNScene(named: "Meshes.scnassets/" + daeFile)
        scene?.rootNode.rotation = SCNVector4(0, -1, 0, 1)
        sceneView.scene = scene
    }
    
    private func updateChoiceLabel() {
        robotChoiceLabel.text = "\(robotChoice + 1)/\(robotCount)"
    }
}
