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
import Level

class ExampleProgramViewController: UIViewController {

    @IBOutlet weak var exampleProgramTable: UITableView! {
        didSet {
            tableDataSource?.delegate = self
            exampleProgramTable.dataSource = tableDataSource
            exampleProgramTable.delegate = tableDataSource
        }
    }

    // MARK: - Observers
    private var cardObserver: Observer?

    // MARK: - Injected properties
    var tableDataSource: ExampleProgramTableDataSource!
    var viewModel: ExampleProgramViewModeling! {
        didSet {
            cardObserver = viewModel.cardName.observeFuture { [weak self] card in
                guard let cardName = card else { return }
                self?.tableDataSource.showExamplesForCard(withName: cardName)
            }
        }
    }

    deinit {
        cardObserver?.release()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let exampleController as ExamplePreviewViewController:
            exampleController.programsViewModel = sender as? ProgramsViewModeling
            exampleController.viewModel.cardName.value = viewModel.cardName.value
        default:
            break
        }
    }
}

// MARK: - ExampleProgramSelectorDelegate
extension ExampleProgramViewController: ExampleProgramSelectorDelegate {
    func editorSelected(editor: ProgramsViewModeling) {
        performSegue(withIdentifier: "showProgramExample", sender: editor)
    }
}
