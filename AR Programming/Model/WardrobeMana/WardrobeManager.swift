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

class WardrobeManager {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static var managedObjectContext = appDelegate.persistentContainer.viewContext
    
    private static var robotFiles: [String] = []
    
    static func getDaeFileNames() -> [String] {
        var daeFiles: [String] = []
        
        if let path = Bundle.main.resourcePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: path + "/Meshes.scnassets")
                
                for name in files {
                    if name.hasSuffix(".dae") {
                        daeFiles.append(String(name.dropLast(4)))
                    }
                }
       
            } catch let error as NSError {
                print(error.description)
            }
        }
        return daeFiles
    }
    
    static func robotChoice() -> String {
        let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")
        
        if let result = try? managedObjectContext.fetch(request){
            if result.count != 0 {
                return result[0].choice!
            } else if result.count == 0 {
                robotFiles = getDaeFileNames()
                setRobotChoice(choice: robotFiles[0])
            }
        }
        
        return robotFiles[0]
    }
    
    static func setRobotChoice(choice: String) {
        managedObjectContext.perform {
            let request = NSFetchRequest<RobotEntity>(entityName: "RobotEntity")
            if let result = try? managedObjectContext.fetch(request){
                if result.count == 0 {
                    let robotEntity = NSEntityDescription.entity(forEntityName: "RobotEntity", in: managedObjectContext)
                    let newRobotEntity = RobotEntity(entity: robotEntity!, insertInto: managedObjectContext)
                    newRobotEntity.setValue(choice, forKey: "choice")
                    appDelegate.saveContext()
                } else {
                    result[0].setValue(choice, forKey: "choice")
                }
                appDelegate.saveContext()
            }
        }
    }
}
