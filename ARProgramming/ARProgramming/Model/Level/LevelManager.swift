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
    
    private let context: CoreDataRepository
    private let levelFactories: [LevelFactory] = [
        QuantityLevelFactory(),
        CleanUpLevelFactory()
    ]
    
    private var levelDirectoryUrl: URL? {
        return Bundle.main.resourceURL?.appendingPathComponent("Levels", isDirectory: true)
    }
    
    var emptylevel: Level {
        return EmptyLevel()
    }
    
    init(context: CoreDataRepository) {
        self.context = context
    }
    
    func loadLevel(byName name: String) throws -> Level {
        guard let levelDirectoryUrl = levelDirectoryUrl
            else { throw LevelLoadingError.noSuchLevel(levelName: name) }
        
        let url = levelDirectoryUrl.appendingPathComponent("\(name).json")
        return try loadLevel(fromUrl: url)
    }
    
    private func loadLevel(fromUrl url: URL) throws -> Level {
        let jsonData: Data
        
        do {
            jsonData = try Data(contentsOf: url)
        } catch {
            throw LevelLoadingError.noSuchLevel(levelName: url.lastPathComponent)
        }
        
        return try loadLevel(fromData: jsonData)
    }
    
    private func loadLevel(fromData data: Data) throws -> Level {
        //Figure out the level type so that we can use the correct LevelFactory
        guard let jsonLevelUntyped = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonLevel = jsonLevelUntyped as? [String:Any],
            let levelType = jsonLevel["type"] as? String else {
                throw LevelLoadingError.badFormat()
        }
        
        for factory in levelFactories {
            if factory.canReadLevel(ofType: levelType) {
                do {
                    let level = try factory.initLevel(json: data)
                    level.unlocked = isLevelUnlocked(withNumber: level.levelNumber)
                    level.levelManager = self
                    return level
                } catch {
                    throw LevelLoadingError.badFormat()
                }
            }
        }
        
        throw LevelLoadingError.unsupportedLevelType(type: levelType)
    }
    
    func loadAllLevels() throws -> [Level] {
        var levels = [Level]()
        
        guard let levelDirectoryUrl = levelDirectoryUrl
            else { return levels }
        
        if let urls = try? FileManager.default.contentsOfDirectory(at: levelDirectoryUrl, includingPropertiesForKeys: nil) {
            for url in urls {
                let level = try loadLevel(fromUrl: url)
                level.levelManager = self
                levels.append(level)
            }
            
            levels.sort { a,b in
                return a.levelNumber < b.levelNumber
            }
            
            markLevel(withNumber: levels[0].levelNumber, asUnlocked: true)
            levels[0].unlocked = true
        }
        
        return levels
    }
    
    private func isLevelUnlocked(withNumber levelNumber: Int) -> Bool {
        let managedObjectContext = context.persistentContainer.viewContext
        let request = NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
        request.predicate = NSPredicate(format: "level = %d", levelNumber)
        
        if let result = try? managedObjectContext.fetch(request){
            if result.count != 0 {
                return result[0].unlocked
            }
        }
        return false
    }
    
    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, whenDone completion: (() -> Void)? = nil) {
        let managedObjectContext = context.persistentContainer.viewContext
        
        managedObjectContext.perform {
            let request = NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
            request.predicate = NSPredicate(format: "level = %d", id)
            if let result = try? managedObjectContext.fetch(request){
                if result.count == 0 {
                    let entity = NSEntityDescription.entity(forEntityName: "LevelEntity", in: managedObjectContext)
                    let levelEntity = LevelEntity(entity: entity!, insertInto: managedObjectContext)
                    levelEntity.setValue(id, forKey: "level")
                    levelEntity.setValue(unlocked, forKey: "unlocked")
                } else {
                    result[0].setValue(unlocked, forKey: "unlocked")
                }
                self.context.saveContext()
                completion?()
            }
        }
    }
}
