//
//  WardrobeViewController.swift
//  AR Programming
//
//  Created by Emil Nielsen on 15/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import SceneKit

class WardrobeViewController: UIViewController {

    @IBOutlet weak var robotChoiceLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!

    // MARK: - Observers
    private var choiceObserver: Observer?
    private var countObserver: Observer?
    private var robotObserver: Observer?

    // MARK: - Injected properties
    var viewModel: WardrobeViewModeling!

    deinit {
        choiceObserver?.release()
        countObserver?.release()
        robotObserver?.release()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true

        choiceObserver = viewModel.robotChoice.observe { [weak self] _ in
            self?.updateChoiceLabel()
        }

        countObserver = viewModel.skinCount.observe { [weak self] _ in
            self?.updateChoiceLabel()
        }

        robotObserver = viewModel.currentRobot.observe { [weak self] robot in
            guard let robot = robot else { return }
            self?.setRobot(named: robot)
        }
    }

    @IBAction func nextRobot(_ sender: UIButton) {
        viewModel.next()
    }

    @IBAction func previousRobot(_ sender: UIButton) {
        viewModel.previous()
    }

    @IBAction func pickRobot(_ sender: UIButton) {
        viewModel.save { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func setRobot(named name: String) {
        let scene = SCNScene(named: "Meshes.scnassets/" + name)
        scene?.rootNode.rotation = SCNVector4(0, -1, 0, 1)
        scene?.rootNode.position = SCNVector3(0.025, 0, -0.5)
        sceneView.scene = scene
    }

    private func updateChoiceLabel() {
        robotChoiceLabel.text = "\(viewModel.robotChoice.value + 1)/\(viewModel.skinCount.value)"
    }
}
