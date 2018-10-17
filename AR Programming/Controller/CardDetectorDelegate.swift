//
//  CardScannerDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol CardDetectorDelegate: AnyObject {
    
    func cardDetector(_ detector: CardDetector, added cardName: String)
    
    func cardDetector(_ detector: CardDetector, removed cardName: String)
    
    func cardDetector(_ detector: CardDetector, scanned cardName: String)
    
    func cardDetectorLostCard(_ detector: CardDetector)
}
