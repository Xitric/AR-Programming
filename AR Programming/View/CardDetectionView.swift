//
//  CardDetectionView.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class CardDetectionView: PassThroughView {
    
    private var overlays = [CardOverlay]()
    private var nextOverlay = 0
    
    weak var delegate: CardDetectionViewDelegate? {
        didSet {
            for overlay in overlays {
                overlay.delegate = delegate
            }
        }
    }
    
    private func getCachedOverlay() -> CardOverlay {
        if nextOverlay == overlays.count {
            let newOverlay = CardOverlay(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            newOverlay.delegate = delegate
            overlays.append(newOverlay)
        }
        
        nextOverlay += 1
        return overlays[nextOverlay - 1]
    }
    
    private func hideRemainingOverlays() {
        for i in nextOverlay ..< overlays.count {
            overlays[i].removeFromSuperview()
        }
    }
    
    private func drawNode(_ node: CardNode?) {
        guard let node = node else {
            return
        }
        
        let overlay = getCachedOverlay()
        overlay.setNode(node)
        
        if (!overlay.isDescendant(of: self)) {
            addSubview(overlay)
        }
        
        for next in node.successors {
            drawNode(next)
        }
    }
    
    func display(program: CardNode?) {
        nextOverlay = 0
        drawNode(program)
        hideRemainingOverlays()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result = super.point(inside: point, with: event)
        if !result {
            delegate?.cardView(didPressCard: nil)
        }
        return result
    }
}

private class CardOverlay: UIImageView {
    
    private var card: Card?
    
    weak var delegate: CardDetectionViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        self.image = UIImage(named: "SurfaceArea")
        self.isUserInteractionEnabled = true
    }
    
    func setNode(_ node: CardNode) {
        let w = node.size.x
        let h = node.size.y
        let x = node.position.x - w / 2
        let y = Double(UIScreen.main.bounds.height) - node.position.y - h / 2
        
        frame = CGRect(x: x, y: y, width: w, height: h)
        card = node.getCard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let card = card {
            delegate?.cardView(didPressCard: card)
        }
    }
}

protocol CardDetectionViewDelegate: class {
    func cardView(didPressCard card: Card?)
}
