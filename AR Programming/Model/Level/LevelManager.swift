//
//  LevelManager.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class LevelManager {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static var managedObjectContext = appDelegate.persistentContainer.viewContext
    
    static func loadLevel(byName name: String) -> Level? {
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(name).json") {
            
            if let jsonData = try? Data(contentsOf: url) {
                if let level = Level(json: jsonData) {
                    if isLevelUnlocked(withNumber: level.levelNumber){
                        level.unlocked = true
                    } else {
                        level.unlocked = false
                    }
                    return level
                }
            }
        }
        
        return nil
    }
    
    static func loadAllLevels() -> [Level] {
        var levels = [Level]()
        
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            
            if let files = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) {
                for file in files {
                    if let jsonData = try? Data(contentsOf: file) {
                        if let level = Level(json: jsonData) {
                            if isLevelUnlocked(withNumber: level.levelNumber){
                                level.unlocked = true
                            } else {
                                level.unlocked = false
                            }
                            levels.append(level)
                        }
                    }
                }
                
                levels.sort { a,b in
                    return a.levelNumber < b.levelNumber
                }
            }
        }
        
        return levels
    }
    
    private static func isLevelUnlocked(withNumber levelNumber: Int) -> Bool {
        let request = NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
        request.predicate = NSPredicate(format: "level = %d", levelNumber)
        if let result = try? managedObjectContext.fetch(request){
            if result.count != 0 {
                return result[0].unlocked
            }
        }
        return false
    }
    
    static func markLevel(withName name: String, asUnlocked unlocked: Bool, whenDone completion: (() -> Void)? = nil) {
        if let level = loadLevel(byName: name) {
            level.unlocked = unlocked
            
            managedObjectContext.perform {
                let request = NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
                request.predicate = NSPredicate(format: "level = %d", level.levelNumber)
                if let result = try? managedObjectContext.fetch(request){
                    if result.count == 0 {
                        let entity = NSEntityDescription.entity(forEntityName: "LevelEntity", in: managedObjectContext)
                        let levelEntity = LevelEntity(entity: entity!, insertInto: managedObjectContext)
                        levelEntity.setValue(level.levelNumber, forKey: "level")
                        levelEntity.setValue(unlocked, forKey: "unlocked")
                        
                    } else {
                        result[0].setValue(unlocked, forKey: "unlocked")
                    }
                    appDelegate.saveContext()
                    completion?()
                }
            }
        }
    }
    
    //Ignore this code, it only exists for development purposes
    private static func saveLevel(_ level: Level) {
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(level.name).json") {
            
            do {
                try level.json?.write(to: url)
            } catch _ {
                //Ignore
            }
        }
    }
}
