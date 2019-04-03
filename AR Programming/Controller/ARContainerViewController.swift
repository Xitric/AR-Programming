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

/// The root controller for the game view.
///
/// This controller is responsible for creating the ARSCNView which, for technical reasons, must be shared between all other controllers for the game views. This is accomplished by using a ContainerView to place the views of other controllers on top of this shared ARSCNView.
class ARContainerViewController: UIViewController {
    
    @IBOutlet weak var arSceneView: ARSCNView! {
        didSet {
            arController = ARController(with: arSceneView)
            arController.frameDelegate = self
        }
    }
    @IBOutlet weak var cardDetectionView: CardDetectionView! {
        didSet {
            cardDetectionView.delegate = self
        }
    }
    
    private var levelViewModel: LevelViewModel?
    private var arController: ARController!
    private var programEditor = ProgramEditor()
    
    private var coordinationController: GameCoordinationViewController!
    
    /// Property used for injecting a level instance into this controller.
    var level: Level?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let overlayController = segue.destination as? GameCoordinationViewController {
            if let level = level {
                levelViewModel = LevelViewModel(level: level)
                
                let state = GameState(levelViewModel: levelViewModel!,
                                      arController: arController,
                                      programEditor: programEditor)
                overlayController.enter(withState: state)
            }
            
            arController.updateDelegate = level
            coordinationController = overlayController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        programEditor.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arController?.start()
        
        //From https://stackoverflow.com/questions/25845855/transparent-navigation-bar-ios
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arController?.stop()
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
    }
}

// MARK: - FrameDelegate
extension ARContainerViewController: FrameDelegate {
    func frameScanner(_ scanner: ARController, didUpdate frame: CVPixelBuffer, withOrientation orientation: CGImagePropertyOrientation) {
        programEditor.newFrame(frame, oriented: orientation, frameWidth: Double(UIScreen.main.bounds.width), frameHeight: Double(UIScreen.main.bounds.height))
    }
}

// MARK: - ProgramEditorDelegate
extension ARContainerViewController: ProgramEditorDelegate {
    func programEditor(_ programEditor: ProgramEditor, createdNew program: Program) {
        cardDetectionView.display(program: program.start)
    }
}

// MARK: UICardRectDelegate
extension ARContainerViewController: CardDetectionViewDelegate {
    func cardView(didPressCard card: Card?) {
        if let card = card {
            coordinationController.goToCardDescriptionView(withCard: card)
        } else {
            coordinationController.goToLevelView()
        }
    }
}
