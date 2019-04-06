//
//  UIImage+Helpers.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 21/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func loadAnimation(named name: String, withFrames frameCount: Int) -> [UIImage] {
        var images = [UIImage]()
        
        for i in 1...frameCount {
            if let frame = UIImage(named: "\(name)\(i).png") {
                images.append(frame)
            }
        }
        
        return images
    }
}
