//
//  PlaneDetectorDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

protocol PlaneDetectorDelegate: class {
    
    /// Tell the plane detector if it should update the detected plane at the current time.
    ///
    /// - Parameter detector: The plane detector.
    /// - Returns: True to enable plane detection, false otherwise.
    func shouldDetectPlanes(_ detector: ARController) -> Bool
    
    /// Provide the plane detector with a graphical representation for the plane it has detected.
    ///
    /// This method is called whenever the plane detector has found a new plane. The delegate is free to provide the plane detecor with any graphical representation of the plane to show to the user. The plane detector itself will update the position of this plane as long as the delegate has enabled plane detection.
    ///
    /// - Parameter detector: The plane detector.
    /// - Returns: The graphical representation of the detected plane.
    func createPlaneNode(_ detector: ARController) -> SCNNode
}
