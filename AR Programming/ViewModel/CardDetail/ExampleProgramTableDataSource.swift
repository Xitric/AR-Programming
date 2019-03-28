//
//  ExampleProgramTableDataSource.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ExampleProgramTableDataSource: NSObject, UITableViewDataSource {
    
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
}
