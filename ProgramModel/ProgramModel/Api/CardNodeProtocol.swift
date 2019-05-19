//
//  CardNodeProtocol.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 08/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

/// A representation of a program statement.
///
/// A CardNode will also contain information about its spatial location in relation to other CardNodes.
public protocol CardNodeProtocol: class {

    var position: simd_double2 { get }
    var size: simd_double2 { get }
    var entryAngle: Double { get }
    var children: [CardNodeProtocol] { get }
    var card: Card { get }
}
