//
//  CardDetectorDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol CardDetectorDelegate: AnyObject {
    
    func cardDetector(_ detector: CardDetector, found cardName: String)
    
    func cardDetector(_ detector: CardDetector, lost cardName: String)
}
