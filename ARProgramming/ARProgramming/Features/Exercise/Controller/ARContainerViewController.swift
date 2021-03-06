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

/// The root controller for the game view.
///
/// This controller is responsible for creating the ARSCNView which, for technical reasons, must be shared between all other controllers for the game views. This is accomplished by using a ContainerView to place the views of other controllers on top of this shared ARSCNView.
class ARContainerViewController: UIViewController {

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

    // MARK: - Observers
    private var editedCardsObserver: Observer?
    private var dragObserver: Observer?

    // MARK: - Injected properties
    var viewModel: ARContainerViewModeling! {
        didSet {
            editedCardsObserver = viewModel.editedCards.observeFuture { [weak self] cards in
                self?.cardDetectionView.display(nodes: cards, program: self!.viewModel.editedProgram.value)
                self?.dragDelegate.currentProgram = self?.viewModel.editedProgram.value
            }
        }
    }
    var dragDelegate: ProgramDragInteractionDelegate! {
        didSet {
            dragObserver = dragDelegate.dragBegan.observeFuture { [weak self] in
                self?.coordinationController.auxiliaryViewCompleted(self!.coordinationController.cardViewController)
            }
        }
    }

    deinit {
        editedCardsObserver?.release()
        dragObserver?.release()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let coordinator = segue.destination as? GameCoordinationViewController {
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

        //The children seemed to have difficulty using drag-n-drop, so we made the delay for picking up the cards much shorter
        if let longPressRecognizer = cardDetectionView.gestureRecognizers?.compactMap({ $0 as? UILongPressGestureRecognizer}).first {
            longPressRecognizer.minimumPressDuration = 0.2
        }
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
