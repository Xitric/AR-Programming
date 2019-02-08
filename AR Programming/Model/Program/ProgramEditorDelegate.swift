//
//  ProgramEditorDelegate.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol ProgramEditorDelegate: class {
    func programEditor(_ programEditor: ProgramEditor, createdNew program: Program)
}
