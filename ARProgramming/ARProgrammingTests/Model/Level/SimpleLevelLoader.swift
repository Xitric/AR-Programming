//
//  SimpleLevelLoader.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
@testable import ARProgramming

class SimpleLevelLoader {
    
    static func getLevelJson(withName name: String) -> Data? {
        if let url = Bundle(for: SimpleLevelLoader.self).resourceURL?
            .appendingPathComponent("Levels", isDirectory: true)
            .appendingPathComponent(name) {
            
            return try? Data(contentsOf: url)
        }
        
        return nil
    }
    
    static func loadLevel<T: Level>(ofType type: T.Type, withName name: String) -> T? {
        if let json = getLevelJson(withName: name) {
            return try? JSONDecoder().decode(type, from: json)
        }
        
        return nil
    }
}
