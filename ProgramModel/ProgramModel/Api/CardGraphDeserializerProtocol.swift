//
//  CardGraphDeserializerProtocol.swift
//  ProgramModel
//  
//  Created by Kasper Schultz Davidsen on 06/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

/// An object for converting between programs and json.
///
/// This can be used as an alternative to a program editor when programs are not constructed from images but rather from configuration files. It is also useful for converting programs into a format that is more easily exchangeable.
public protocol CardGraphDeserializerProtocol {
    func serialize(_ program: ProgramProtocol) -> Data?
    func serialize(_ editor: ProgramEditorProtocol) -> Data?
    func deserialize(from data: Data) throws -> ProgramEditorProtocol
}
