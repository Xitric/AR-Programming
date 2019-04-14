//
//  ExampleProgramTableDataSource.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class ExampleProgramTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var examples = [ProgramsViewModeling]()
    private let deserializer: CardGraphDeserializerProtocol
    
    weak var delegate: ExampleProgramSelectorDelegate?
    
    init(deserializer: CardGraphDeserializerProtocol) {
        self.deserializer = deserializer
    }
    
    func showExamplesForCard(withName name: String) {
        if let folderUrl = Bundle(for: type(of: self)).resourceURL?
            .appendingPathComponent("ExamplePrograms", isDirectory: true)
            .appendingPathComponent(name, isDirectory: true),
            let urls = try? FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil) {
            
            for url in urls {
                if let data = try? Data(contentsOf: url),
                    let editor = try? deserializer.deserialize(from: data) {
                    examples.append(ProgramsViewModel(editor: editor))
                }
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "ProgramExampleCell", for: indexPath)
        
        if let row = row as? ExampleProgramTableViewCell {
            row.programView.programsViewModel = examples[indexPath.row]
        }
        
        return row
    }
    
    //MARK: - ProgramDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.editorSelected(editor: examples[indexPath.row])
    }
}

protocol ExampleProgramSelectorDelegate: class {
    func editorSelected(editor: ProgramsViewModeling)
}
