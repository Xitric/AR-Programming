//
//  ExampleProgramTableDataSource.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ExampleProgramTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var examples = [ProgramEditor]()
    
    weak var delegate: ExampleProgramSelectorDelegate?
    
    init(exampleBaseName: String) {
        if let folderUrl = Bundle.main.resourceURL?
            .appendingPathComponent("ExamplePrograms", isDirectory: true)
            .appendingPathComponent(exampleBaseName, isDirectory: true),
            let urls = try? FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil) {
            
            for url in urls {
                if let data = try? Data(contentsOf: url),
                    let editor = try? CardGraphDeserializer().deserialize(from: data) {
                    examples.append(editor)
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
            row.executableProgramView.editor = examples[indexPath.row]
        }
        
        return row
    }
    
    //MARK: - ProgramDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.programSelected(program: examples[indexPath.row].main)
    }
}

protocol ExampleProgramSelectorDelegate: class {
    func programSelected(program: Program)
}
