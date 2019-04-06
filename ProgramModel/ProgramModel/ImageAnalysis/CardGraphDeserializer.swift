//
//  CardGraphDeserializer.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

public protocol CardGraphDeserializer {
    func deserialize(from data: Data) throws -> ProgramEditor
}
