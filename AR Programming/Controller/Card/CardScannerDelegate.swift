//
//  CardScannerDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol CardScannerDelegate: AnyObject {
    
    func cardScanner(_ scanner: ARController, scanned card: Card)
    
    func cardScannerLostCard(_ scanner: ARController)
}
