//
//  WardrobeManager.swift
//  AR Programming
//
//  Created by Emil Nielsen on 19/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WardrobeManager: WardrobeProtocol {
    
    private let context: CoreDataRepository
    private let targetDirectory = "/Meshes.scnassets/Robot"
    private var robotFiles: [String] = []
    
    init(context: CoreDataRepository) {
        self.context = context
    }
    
    func getFileNames() -> [String] {
        var fileNames: [String] = []
        
        if let path = Bundle(for: type(of: self)).resourcePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: path + targetDirectory)
                
                for name in files {
                    let extensionIndex = name.firstIndex(of: ".") ?? name.endIndex
                    let fileName = "Robot/\(name[..<extensionIndex])"
                    fileNames.append(fileName)
                }
            } catch let error as NSError {
                print(error.description)
            }
        }
        
        return fileNames
    }
    
    func selectedRobotSkin() -> String {
        let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")
        
        let managedObjectContext = context.persistentContainer.viewContext
        if let result = try? managedObjectContext.fetch(request){
            if result.count != 0 {
                return result[0].choice!
            }
        }
        
        robotFiles = getFileNames()
        setRobotChoice(choice: robotFiles[0], callback: nil)
        return robotFiles[0]
    }
    
    func setRobotChoice(choice: String, callback: (() -> Void)?) {
        let managedObjectContext = context.persistentContainer.viewContext
        
        managedObjectContext.perform { [unowned self] in
            let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")
            if let result = try? managedObjectContext.fetch(request) {
                if result.count == 0 {
                    let robotEntity = NSEntityDescription.entity(forEntityName: "RobotEntity", in: managedObjectContext)
                    let newRobotEntity = RobotEntity(entity: robotEntity!, insertInto: managedObjectContext)
                    newRobotEntity.setValue(choice, forKey: "choice")
                    self.context.saveContext()
                } else {
                    result[0].setValue(choice, forKey: "choice")
                }
                
                self.context.saveContext()
                callback?()
            }
        }
    }
}

protocol WardrobeProtocol {
    func selectedRobotSkin() -> String
    func getFileNames() -> [String]
    func setRobotChoice(choice: String, callback: (() -> Void)?)
}
