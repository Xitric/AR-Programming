//
//  LevelCollectionViewCell.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 19/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit
import Level

class LevelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var levelPreview: UIImageView!
    @IBOutlet weak var lock: UIImageView!
    @IBOutlet weak var levelName: UILabel!
    @IBOutlet weak var levelType: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var level: LevelProtocol?
    
    var unlocked: Bool? {
        didSet {
            lock.isHidden = unlocked ?? false
            isUserInteractionEnabled = unlocked ?? false
        }
    }
}
