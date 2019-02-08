//
//  ProgramDelegate.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 07/02/2019.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol ProgramDelegate: class {
    func programBegan(_ program: Program)
    func program(_ program: Program, executed card: Card)
    func programEnded(_ program: Program)
}
