//
//  LevelCollectionViewCell.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var levelPreview: UIImageView!
    @IBOutlet weak var lock: UIImageView!
    @IBOutlet weak var levelName: UILabel!
    
    var completed: Bool? {
        didSet {
            lock.isHidden = completed ?? false
        }
    }
    
    @IBAction func levelInfo(_ sender: UIButton) {
        
    }
}