//
//  CardCommand.swift
//  AR Programming
//
//  Created by Emil Nielsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol CardCommand {
    func execute(modelIn3D animatableNode: AnimatableNode)
}
