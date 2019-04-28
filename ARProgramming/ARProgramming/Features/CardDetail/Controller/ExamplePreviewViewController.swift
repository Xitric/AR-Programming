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
            
            //Display empty level for preview
            levelViewModel.anchor(at: previewScene.scene?.rootNode)
            
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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var programView: InteractiveProgramView! {
        didSet {
            programView.viewModel = programsViewModel
        }
    }
    
    //MARK: - Observers
    private var levelObserver: Observer!
    private var runningObserver: Observer!
    
    //MARK: - Injected properties
    var viewModel: ExampleProgramViewModeling!
    var levelViewModel: LevelSceneViewModeling! {
        didSet {
            levelViewModel.setLevel(level: viewModel.level)
            
            levelObserver = levelViewModel.levelRedrawn.observeFuture { [weak self] in
                //Add grid floor
                let ground = SCNNode(geometry: SCNPlane(width: 5, height: 5))
                ground.eulerAngles.x = -.pi / 2
                ground.geometry?.materials.first?.diffuse.contents = UIImage(named: "ExampleProgramGridFloor.png")
                self?.levelViewModel.addNode(ground)
            }
        }
    }
    var programsViewModel: ProgramsViewModeling! {
        didSet {
            programsViewModel.cardSize.value = 100
            runningObserver = programsViewModel.running.observeFuture { [weak self] running in
                self?.playButton.isEnabled = !running
            }
        }
    }
    
    deinit {
        levelObserver.release()
        runningObserver.release()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runProgram()
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        viewModel.reset()
        playButton.isEnabled = false
        runProgram()
    }
    
    @IBAction func onDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playButton.isEnabled = false
    }
    
    private func runProgram() {
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 0.5) { [weak self] in
            if let entity = self?.viewModel.player {
                self?.programsViewModel.start(on: entity)
            } else {
                self?.playButton.isEnabled = true
            }
        }
    }
}

//MARK: - SCNSceneRendererDelegate
extension ExamplePreviewViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        viewModel.update(currentTime: time)
    }
}
