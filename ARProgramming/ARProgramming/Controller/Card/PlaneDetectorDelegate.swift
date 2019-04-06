//
//  PlaneDetectorDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol PlaneDetectorDelegate: class {
    func shouldDetectPlanes(_ detector: ARController) -> Bool
    func planeDetector(_ detector: ARController, found plane: Plane)
}
