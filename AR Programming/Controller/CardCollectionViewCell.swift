//
//  CardCollectionViewCell.swift
//  AR Programming
//
//  Created by Emil Nielsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    var cardTitle: String?
    var cardDescription: String?
}
