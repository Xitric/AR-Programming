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
    static var emptylevel: Level {
        return EmptyLevel()
    }
    
    private static let levelFactories: [LevelFactory] = [
        QuantityLevelFactory(),
        CleanUpLevelFactory()
    ]
    
    private static var levelDirectoryUrl: URL? {
        return Bundle.main.resourceURL?.appendingPathComponent("Levels", isDirectory: true)
    }
    
    static func loadLevel(byName name: String) throws -> Level {
        guard let levelDirectoryUrl = levelDirectoryUrl
            else { throw LevelLoadingError.noSuchLevel(levelName: name) }
        
        let url = levelDirectoryUrl.appendingPathComponent("\(name).json")
        return try loadLevel(fromUrl: url)
    }
    
    private static func loadLevel(fromUrl url: URL) throws -> Level {
        let jsonData: Data
        
        do {
            jsonData = try Data(contentsOf: url)
        } catch {
            throw LevelLoadingError.noSuchLevel(levelName: url.lastPathComponent)
        }
        
        let level = try loadLevel(fromData: jsonData)
        level.unlocked = isLevelUnlocked(withNumber: level.levelNumber)
        
        return level
    }
    
    private static func loadLevel(fromData data: Data) throws -> Level {
        //Figure out the level type so that we can use the correct LevelFactory
        guard let jsonLevelUntyped = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonLevel = jsonLevelUntyped as? [String:Any],
            let levelType = jsonLevel["type"] as? String else {
                throw LevelLoadingError.badFormat()
        }
    
        for factory in levelFactories {
            if factory.canReadLevel(ofType: levelType) {
                do {
                    return try factory.initLevel(json: data)
                } catch {
                    throw LevelLoadingError.badFormat()
                }
            }
        }
        
        throw LevelLoadingError.unsupportedLevelType(type: levelType)
    }
    
    static func loadAllLevels() throws -> [Level] {
        var levels = [Level]()
        
        guard let levelDirectoryUrl = levelDirectoryUrl
            else { return levels }
        
        if let urls = try? FileManager.default.contentsOfDirectory(at: levelDirectoryUrl, includingPropertiesForKeys: nil) {
            for url in urls {
                let level = try loadLevel(fromUrl: url)
                levels.append(level)
            }
            
            levels.sort { a,b in
                return a.levelNumber < b.levelNumber
            }
            
            markLevel(withName: levels[0].name, asUnlocked: true)
            levels[0].unlocked = true
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
        if let level = try? loadLevel(byName: name) {
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
}
