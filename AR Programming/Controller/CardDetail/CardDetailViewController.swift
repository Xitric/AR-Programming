//
//  CardDetailViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardDetailViewController: UIViewController, ExampleProgramSelectorDelegate, SCNSceneRendererDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var programExampleTable: UITableView! {
        didSet {
            programExampleTable.dataSource = tableDataSource
            programExampleTable.delegate = tableDataSource
        }
    }
    @IBOutlet weak var sceneView: SCNView! {
        didSet {
            sceneView.autoenablesDefaultLighting = true
            sceneView.scene = SCNScene()
            sceneView.scene?.rootNode.rotation = SCNVector4(0, -1, 0, 1)
            sceneView.delegate = self
            sceneView.isPlaying = true
            
            //Load empty level for previews
            levelViewModel = LevelViewModel(level: LevelManager.emptylevel)
            sceneView.scene?.rootNode.addChildNode(levelViewModel.levelView)
            
            //Set up camera
            let camera = SCNNode()
            camera.camera = SCNCamera()
            camera.camera?.zNear = 0.02
            camera.camera?.zFar = 10
            camera.position = SCNVector3(0, 0.9, 0.5)
            camera.rotation = SCNVector4(-1, -0.033, -0.025, 1.1)
            sceneView.pointOfView = camera
            
            //Add grid floor
            let ground = SCNNode(geometry: SCNPlane(width: 5, height: 5))
            ground.eulerAngles.x = -.pi / 2
            ground.geometry?.materials.first?.diffuse.contents = UIImage(named: "ExampleProgramGridFloor.png")
            levelViewModel.levelView.addChildNode(ground)
        }
    }
    
    private var levelViewModel: LevelViewModel!
    
    private lazy var tableDataSource: ExampleProgramTableDataSource = {
        let source = ExampleProgramTableDataSource()
        source.delegate = self
        return source
    }()
    
    var card: Card!
    var cardPreview: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = NSLocalizedString("\(card.internalName).name", comment: "")
        summaryLabel.text = NSLocalizedString("\(card.internalName).summary", comment: "")
        descriptionLabel.text = NSLocalizedString("\(card.internalName).description", comment: "")
        previewImage.image = cardPreview
        
        typeLabel.text = NSLocalizedString("cardType.\(card.type)", comment: "")
        if card.supportsParameter {
            parameterLabel.text = NSLocalizedString("card.parameterSupported", comment: "") + " "
                + NSLocalizedString("\(card.internalName).parameter", comment: "")
        } else {
            parameterLabel.text = NSLocalizedString("card.parameterUnsupported", comment: "")
        }
        
        programExampleTable.reloadData()
    }
    
    func entityForProgram() -> Entity {
        return levelViewModel.levelModel.entityManager.player
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let arContainer = segue.destination as? ARContainerViewController {
            arContainer.level = LevelManager.emptylevel
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        levelViewModel.levelModel.update(currentTime: time)
    }
}
