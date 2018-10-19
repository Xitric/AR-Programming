//
//  CardScannerDelegate.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

protocol CardScannerDelegate: AnyObject {
    
    func cardScanner(_ scanner: CardScanner, scanned cardName: String)
    
    func cardScannerLostCard(_ scanner: CardScanner)
}
