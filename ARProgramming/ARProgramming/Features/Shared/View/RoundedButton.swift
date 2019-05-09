//
//  RoundedButton.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 30/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = frame.size.height / 2
    }
}
