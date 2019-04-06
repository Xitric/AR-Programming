//
//  ExampleProgramViewController.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 01/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ProgramModel

class ExampleProgramViewController: UIViewController {
    
    @IBOutlet weak var exampleProgramTable: UITableView!
    @IBOutlet weak var previewScene: SCNView! {
        didSet {
            previewScene.autoenablesDefaultLighting = true
            previewScene.scene = SCNScene()
            previewScene.scene?.rootNode.rotation = SCNVector4(0, -1, 0, 1)
            previewScene.delegate = self
            previewScene.isPlaying = true
            
            //Load empty level for previews
            levelViewModel = LevelViewModel(level: LevelManager.emptylevel)
            previewScene.scene?.rootNode.addChildNode(levelViewModel.levelView)
            
            //Set up camera
            let camera = SCNNode()
            camera.camera = SCNCamera()
            camera.camera?.zNear = 0.02
            camera.camera?.zFar = 10
            camera.position = SCNVector3(0, 0.9, 0.5)
            camera.rotation = SCNVector4(-1, -0.033, -0.025, 1.1)
            previewScene.pointOfView = camera
            
            //Add grid floor
            let ground = SCNNode(geometry: SCNPlane(width: 5, height: 5))
            ground.eulerAngles.x = -.pi / 2
            ground.geometry?.materials.first?.diffuse.contents = UIImage(named: "ExampleProgramGridFloor.png")
            levelViewModel.levelView.addChildNode(ground)
        }
    }
    
    private var tableDataSource: ExampleProgramTableDataSource!
    private var levelViewModel: LevelViewModel!
    
    var deserializer: CardGraphDeserializer!
    
    func showExamples(forCard card: Card) {
        tableDataSource = ExampleProgramTableDataSource(exampleBaseName: card.internalName, deserializer: deserializer)
        tableDataSource.delegate = self
        
        exampleProgramTable.dataSource = tableDataSource
        exampleProgramTable.delegate = tableDataSource
    }
}

//MARK: - ExampleProgramSelectorDelegate
extension ExampleProgramViewController: ExampleProgramSelectorDelegate, ProgramDelegate {
    
    func programSelected(program: Program) {
        levelViewModel.levelModel.reset()
        exampleProgramTable.allowsSelection = false
        program.delegate = self
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 0.5) { [weak self] in
            if let entity = self?.levelViewModel.levelModel.entityManager.player {
                program.run(on: entity)
            } else {
                self?.exampleProgramTable.allowsSelection = true
            }
        }
    }
    
    func programBegan(_ program: Program) {
        //Ignore
    }
    
    func program(_ program: Program, executed card: Card) {
        //Ignore
    }
    
    func programEnded(_ program: Program) {
        DispatchQueue.main.async { [weak self] in
            self?.exampleProgramTable.allowsSelection = true
        }
    }
}

//MARK: - SCNSceneRendererDelegate
extension ExampleProgramViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        levelViewModel.levelModel.update(currentTime: time)
    }
}
