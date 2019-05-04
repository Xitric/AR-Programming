//
//  PassThroughView.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class PassThroughView: UIView {

    //By courtesy of:
    //https://stackoverflow.com/questions/3046813/how-can-i-click-a-button-behind-a-transparent-uiview
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
