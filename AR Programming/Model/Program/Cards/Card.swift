//
//  Card.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol Card {
    var name: String { get }
    var internalName: String { get }
    var summary: String { get }
    var description: String { get }
    
    func getAction() -> ActionComponent?
}
