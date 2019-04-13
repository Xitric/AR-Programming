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
import ProgramModel
import Level

/// The root controller for the game view.
///
/// This controller is responsible for creating the ARSCNView which, for technical reasons, must be shared between all other controllers for the game views. This is accomplished by using a ContainerView to place the views of other controllers on top of this shared ARSCNView.
class ARContainerViewController: UIViewController, GameplayController {
    
    @IBOutlet weak var arSceneView: ARSCNView! {
        didSet {
            arController.sceneView = arSceneView
            arController.frameDelegate = self
        }
    }
    @IBOutlet weak var cardDetectionView: CardDetectionView! {
        didSet {
            cardDetectionView.delegate = self
            cardDetectionView.addInteraction(UIDragInteraction(delegate: dragDelegate))
        }
    }
    
    private var coordinationController: GameCoordinationViewController!
    
    //MARK: - Injected properties
    var levelViewModel: LevelViewModel? {
        didSet {
            arController.updateDelegate = levelViewModel
        }
    }
    var programEditor: ProgramEditorProtocol! {
        didSet {
            programEditor.delegate = self
        }
    }
    var arController: ARController!
    var dragDelegate: ProgramDragInteractionDelegate!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let overlayController = segue.destination as? GameCoordinationViewController {
            overlayController.levelViewModel = levelViewModel
            coordinationController = overlayController
        }
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
    func programEditor(_ programEditor: ProgramEditorProtocol, createdNew program: ProgramProtocol) {
        cardDetectionView.display(nodes: programEditor.allCards, program: program.start)
        dragDelegate.currentProgram = program
    }
}

// MARK: UICardRectDelegate
extension ARContainerViewController: CardDetectionViewDelegate {
    func cardView(didPressCard card: Card?) {
        coordinationController.goToCardDescriptionView(withCard: card)
    }
}
