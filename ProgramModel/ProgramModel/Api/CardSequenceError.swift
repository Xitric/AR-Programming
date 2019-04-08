//
//  CardSequenceError.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// An error that is thrown whenever something went wrong when trying to construct a program.
///
/// - missingStart: Thrown when the program sequence has no start or function card.
/// - unknownCode: Thrown when an unknown code is encountered in a program sequence.
/// - syntax: Thrown when the program sequence is malformed.
public enum CardSequenceError: Error, Equatable {
    //TODO: We could probably pass the CardNode that threw this error as part of the error itself to make it easier to display on the screen
    case missingStart
    case unknownCode(code: String)
    case syntax(message: String)
}
