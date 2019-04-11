//
//  CardGraphDeserializerProtocol.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// An object for reading program sequences out of a json file. This is an alternative to using a program editor directly when programs are not constructed from images but rather from configuration files.
public protocol CardGraphDeserializerProtocol {
    func deserialize(from data: Data) throws -> ProgramEditorProtocol
}
