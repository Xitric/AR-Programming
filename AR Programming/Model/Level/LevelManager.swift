//
//  LevelManager.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 08/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public class LevelManager {
    
    static func loadLevel(byName name: String) -> Level? {
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(name).json") {
            
            if let jsonData = try? Data(contentsOf: url) {
                if let level = Level(json: jsonData) {
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
    
    static func markLevel(withName name: String, asUnlocked unlocked: Bool) {
        if let level = loadLevel(byName: name) {
            level.unlocked = unlocked
            saveLevel(level)
        }
    }
    
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
