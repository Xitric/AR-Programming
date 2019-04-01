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
    private var levelViewModel: LevelViewModel?
    
    var level: Level?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameplayController = segue.destination as? GameplayController {
            if let level = level {
                levelViewModel = LevelViewModel(level: level)
            }
            arController?.updateDelegate = level
            
            gameplayController.enter(withLevel: levelViewModel, inEnvironment: arController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arController?.start()
        
        //From https://stackoverflow.com/questions/25845855/transparent-navigation-bar-ios
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arController?.stop()
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.view.backgroundColor = nil
    }
}
