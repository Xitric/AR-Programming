//
//  CardCollection.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// A container storing all cards available for programming.
public protocol CardCollection {
    var cards: [Card] { get }
}

