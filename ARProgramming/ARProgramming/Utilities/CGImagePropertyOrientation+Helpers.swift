//
//  CGImagePropertyOrientation+Helpers.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 06/02/2019.
//

import Foundation
import UIKit

extension CGImagePropertyOrientation {
    
    //From
    //https://developer.apple.com/documentation/imageio/cgimagepropertyorientation
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
    
    //Adapted from
    //https://developer.apple.com/documentation/arkit/using_vision_in_real_time_with_arkit
    init(_ deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portraitUpsideDown: self = .left
        case .landscapeLeft, .faceUp: self = .up
        case .landscapeRight: self = .down
        default: self = .right
        }
    }
}
