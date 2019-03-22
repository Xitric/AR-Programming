//
//  CardRect.swift
//  AR Programming
//  
//  Created by Emil Nielsen on 21/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit

class CardRect: UIView {
    
    var card: Card!
    var viewController: UICardRectDelegate?
    
    init(frame: CGRect, card: Card, viewController: UICardRectDelegate?){
        self.card = card
        self.viewController = viewController
        let rect = CGRect()
        super.init(frame: rect)
        setupFromXib()
    }
    
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewController?.cardRect(self, didPressCard: self.card)
    }
}

protocol UICardRectDelegate {
     func cardRect(_ cardRect: CardRect, didPressCard card: Card)
}
