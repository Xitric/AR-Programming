//
//  CardSequenceProgressDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 08/11/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol CardSequenceProgressDelegate: AnyObject {
    
    func cardSequence(robot: AnimatableNode, executed card: Card)
    
    func cardSequenceFinished(robot: AnimatableNode)
}
