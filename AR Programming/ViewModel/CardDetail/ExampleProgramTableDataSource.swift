//
//  ExampleProgramTableDataSource.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ExampleProgramTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, ProgramDelegate {
    
    private weak var tableView: UITableView?
    private let editor = ProgramEditor()
    private var program: Program!
    
    weak var delegate: ExampleProgramSelectorDelegate?
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "ProgramExampleCell", for: indexPath)
        
//        if let row = row as? CardCollectionViewCell {
//            let sectionType = viewModel.cardTypes[indexPath.section]
//            let card = viewModel.cards(ofType: sectionType)[indexPath.item]
//            let cardImage = UIImage(named: card.internalName)
//
//            cell.image.image = cardImage
//            cell.card = card
//        }
        
        return row
    }
    
    //MARK: - ProgramDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView = tableView
        tableView.allowsSelection = false
        
        editor.reset()
        let pv = ProgramView()
        program = pv.program
        program.delegate = self
        program.state = editor
        if let entity = delegate?.entityForProgram() {
            program.run(on: entity)
        }
    }
    
    //MARK: - UITableViewDelegate
    func programBegan(_ program: Program) {
        //Ignored
    }
    
    func program(_ program: Program, executed card: Card) {
        //Ignored
    }
    
    func programEnded(_ program: Program) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.allowsSelection = true
        }
    }
}

protocol ExampleProgramSelectorDelegate: class {
    func entityForProgram() -> Entity
}
