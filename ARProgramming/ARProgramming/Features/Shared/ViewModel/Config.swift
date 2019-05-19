//
//  Config.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 02/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class Config {

    static func read<T>(configFile: String, toType type: T.Type) -> T? where T: Decodable {
        if let url = Bundle(for: Config.self).url(forResource: configFile, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            return try? JSONDecoder().decode(T.self, from: data)
        }

        return nil
    }
}
