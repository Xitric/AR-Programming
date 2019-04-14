//
//  SubtitleLabel.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 21/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SubtitleLabel: UIView {
    
    @IBOutlet weak var label: UILabel!
    
    @IBInspectable var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    //MARK: XIB Boilerplate
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromXib()
    }
    
    private func setupFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        self.backgroundColor = .clear
    }
}
