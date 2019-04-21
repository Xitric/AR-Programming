//
//  ExamplePreviewViewController.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 21/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import Level

class ExamplePreviewViewController: UIViewController {
    
    @IBOutlet weak var previewScene: SCNView! {
        didSet {
            previewScene.autoenablesDefaultLighting = true
            previewScene.scene = SCNScene()
            previewScene.scene?.rootNode.rotation = SCNVector4(0, -1, 0, 1)
            previewScene.delegate = self
            previewScene.isPlaying = true
            
            //Load empty level for preview
            previewLevelViewModel.anchor(at: previewScene.scene?.rootNode)
            
            //Set up camera
            let camera = SCNNode()
            camera.camera = SCNCamera()
            camera.camera?.zNear = 0.02
            camera.camera?.zFar = 10
            camera.position = SCNVector3(0, 0.9, 0.5)
            camera.rotation = SCNVector4(-1, -0.033, -0.025, 1.1)
            previewScene.pointOfView = camera
        }
    }
    @IBOutlet weak var programView: ProgramView! {
        didSet {
            programView.scale = 100
            programView.programsViewModel = viewModel
        }
    }
    @IBOutlet weak var playButton: UIButton!
    
    //MARK: - Injected properties
    var levelRepository: LevelRepository!
    var previewLevelViewModel: LevelViewModeling! {
        didSet {
            previewLevelViewModel.display(level: levelRepository.emptylevel)
            
            //Add grid floor
            let ground = SCNNode(geometry: SCNPlane(width: 5, height: 5))
            ground.eulerAngles.x = -.pi / 2
            ground.geometry?.materials.first?.diffuse.contents = UIImage(named: "ExampleProgramGridFloor.png")
            previewLevelViewModel.addNode(ground)
        }
    }
    var viewModel: ProgramsViewModeling! {
        didSet {
            viewModel.running.onValue = { [weak self] running in
                self?.playButton.isEnabled = !running
            }
        }
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        previewLevelViewModel.reset()
        playButton.isEnabled = false

        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 0.5) { [weak self] in
            if let entity = self?.previewLevelViewModel.player {
                self?.viewModel.start(on: entity)
            } else {
                self?.playButton.isEnabled = true
            }
        }
    }
    
    @IBAction func onDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - SCNSceneRendererDelegate
extension ExamplePreviewViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        previewLevelViewModel.update(currentTime: time)
    }
}
