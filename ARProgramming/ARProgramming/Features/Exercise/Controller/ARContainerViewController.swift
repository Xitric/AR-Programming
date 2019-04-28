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
            viewModel.arController.sceneView = arSceneView
        }
    }
    @IBOutlet weak var cardDetectionView: CardDetectionView! {
        didSet {
            cardDetectionView.delegate = self
            cardDetectionView.addInteraction(UIDragInteraction(delegate: dragDelegate))
        }
    }
    
    private var coordinationController: GameCoordinationViewController!
    
    //MARK: - Observers
    private var editedCardsObserver: Observer?
    
    //MARK: - Injected properties
    var viewModel: ARContainerViewModeling! {
        didSet {
            editedCardsObserver = viewModel.editedCards.observeFuture { [weak self] cards in
                self?.cardDetectionView.display(nodes: cards, program: self!.viewModel.editedProgram.value)
                self?.dragDelegate.currentProgram = self?.viewModel.editedProgram.value
            }
        }
    }
    var dragDelegate: ProgramDragInteractionDelegate!
    var level: ObservableProperty<LevelProtocol>? {
        didSet {
            if let level = level {
                viewModel.setLevel(level: level)
            }
        }
    }
    
    deinit {
        editedCardsObserver?.release()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let coordinator = segue.destination as? GameCoordinationViewController {
            coordinator.level = level
            coordinationController = coordinator
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.start()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stop()
        self.navigationController?.navigationBar.isHidden = false
    }
}

// MARK: UICardRectDelegate
extension ARContainerViewController: CardDetectionViewDelegate {
    func cardView(didPressCard card: Card?) {
        if let card = card {
            coordinationController.goToCardDescriptionView(withCard: card)
        }
    }
}
