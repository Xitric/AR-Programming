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
    
    //MARK: - Injected properties
    var tableDataSource: ExampleProgramTableDataSource!
    var levelRepository: LevelRepository!
    var gameLevelViewModel: LevelViewModeling! {
        didSet {
            gameLevelViewModel.display(level: levelRepository.emptylevel)
        }
    }
    
    func showExamples(forCard card: Card) {
        tableDataSource?.showExamplesForCard(withName: card.internalName)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let exampleController as ExamplePreviewViewController:
            exampleController.viewModel = sender as? ProgramsViewModeling
        case let arContainer as ARContainerViewController:
            arContainer.levelViewModel = gameLevelViewModel
        default:
            break
        }
    }
}

//MARK: - ExampleProgramSelectorDelegate
extension ExampleProgramViewController: ExampleProgramSelectorDelegate {
    func editorSelected(editor: ProgramsViewModeling) {
        performSegue(withIdentifier: "showProgramExample", sender: editor)
    }
}
