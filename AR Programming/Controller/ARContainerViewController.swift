//
//  ARContainerViewController.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 07/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class ARContainerViewController: UIViewController {

    @IBOutlet weak var arSceneView: ARSCNView!{
        didSet {
            arController = ARController(with: arSceneView)
        }
    }
    
    private var arController: ARController?
    private var modelLoader: EntityModelLoader?
    
    var level: Level?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameplayController = segue.destination as? GameplayController {
            gameplayController.enter(withLevel: level, inEnvironment: arController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let level = level {
            modelLoader = EntityModelLoader(entityManager: level.entityManager, scene: arSceneView.scene)
        }
        arController?.updateDelegate = level
    }
    
    //        player.addComponent(ResourceComponent(resourceIdentifier: "Meshes.scnassets/uglyBot.dae"))
    //        other.addComponent(ResourceComponent(resourceIdentifier: "Meshes.scnassets/Bot.dae")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arController?.start()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arController?.stop()
    }
}
