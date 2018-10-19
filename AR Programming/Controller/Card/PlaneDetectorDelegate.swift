//
//  PlaneDetectorDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol PlaneDetectorDelegate: AnyObject {
    
    func shouldDetectPlanes(_ detector: PlaneDetector) -> Bool
    
    func planeDetector(_ detector: PlaneDetector, found plane: Plane)
}
