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
    
    @IBOutlet var rectView: UIView!
    var card: Card?
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
        Bundle.main.loadNibNamed("CardRect", owner: self, options: nil)
        rectView.frame = self.bounds
        rectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(rectView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touchView = touches.first
        if (touchView?.view?.tag = 1) != nil {
            self.message(message: "Touches began in cardRect") //view1.tag = 1
        }
    }
    
    private func message(message:String){
        print(message)
        viewController?.cardRect(self, didPressCard: self.card)
    }
}

protocol UICardRectDelegate {
     func cardRect(_ cardRect: CardRect, didPressCard card: Card?)
}
