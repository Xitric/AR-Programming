//
//  ShadowedButton.swift
//  ARProgramming
//  
//  Created by Kasper Schultz Davidsen on 14/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowedButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize()
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        clipsToBounds = false
    }
}
