//
//  PlayViewController.swift
//  AR Programming
//
//  Created by user143563 on 10/15/18.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scanNavigationBar: UINavigationBar!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var levelsButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
            arController = ARController(with: sceneView)
        }
    }
    
    private var levelViewController: LevelViewController?
    private var scanViewController: ScanViewController?
    private var arController: ARController?
    private var level: Level? {
        didSet {
            levelViewController?.level = level
            arController?.cardMapper = level
            
        }
    }
    
    private var isScanning: Bool = false {
        didSet {
            scanNavigationBar.isHidden = !isScanning
            scanView.isHidden = !isScanning
            
            playView.isHidden = isScanning
            scanButton.isHidden = isScanning
            levelsButton.isHidden = isScanning
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        levelViewController?.arController = arController
        arController?.cardScannerDelegate = scanViewController
        arController?.planeDetectorDelegate = levelViewController
        arController?.start()

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        arController?.stop()

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Inspired by:
    //https://medium.com/@superpeteblaze/ios-swift-tip-getting-references-to-container-child-view-controllers-653fe58e6f5e
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Use this trick to get access to the controllers of the child views
        switch segue.destination {
        case let levelController as LevelViewController:
            self.levelViewController = levelController
        case let scanController as ScanViewController:
            self.scanViewController = scanController
        default:
            break
        }
    }
    
    @IBAction func startScanning(_ sender: UIButton) {
        isScanning = true
    }
    
    @IBAction func doneScanning(_ sender: UIBarButtonItem) {
        isScanning = false
    }
    
    @IBAction func unwindToPlayView(segue: UIStoryboardSegue) {
        if let levelSelector = segue.source as? LevelSelectViewController {
            level = levelSelector.selectedLevel
        }
    }
}
