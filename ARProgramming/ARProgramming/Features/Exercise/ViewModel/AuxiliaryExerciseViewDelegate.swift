//
//  AuxiliaryExerciseViewDelegate.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 13/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

/// Delegate for being notified whenever an auxiliary view such as surface detection or card information has completed and the focus should be switched to the main exercise view.
protocol AuxiliaryExerciseViewDelegate: class {
    func auxiliaryViewCompleted(_ controller: UIViewController)
}
