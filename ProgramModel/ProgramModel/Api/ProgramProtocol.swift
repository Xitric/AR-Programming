//
//  ProgramProtocol.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 08/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import EntityComponentSystem

/// A program represents a tree of CardNodeProtocol objects that each abstract a statement of executable code.
///
/// As such, a protocol is an abstraction over a function or a method from other programming languages. Each program is called by using the _run(on)_ method.
public protocol ProgramProtocol: class {
    var delegate: ProgramDelegate? { get set }
    var start: CardNodeProtocol? { get }
    
    /// Executes the statements of this program on the supplied Entity.
    ///
    /// To increase flexibility, any statement that is not meaningful for the supplied Entiy will simply be skipped rather than throwing an error. For instance, executing a movement action on an Entity with no position will simply do nothing.
    ///
    /// - Parameter entity: The entity to execute the program on.
    func run(on entity: Entity)
}

/// An object that can receive callbacks at various times during the execution of a program.
public protocol ProgramDelegate: class {
    func programBegan(_ program: ProgramProtocol)
    func program(_ program: ProgramProtocol, willExecute cardNode: CardNodeProtocol)
    func program(_ program: ProgramProtocol, executed cardNode: CardNodeProtocol)
    func programEnded(_ program: ProgramProtocol)
}

