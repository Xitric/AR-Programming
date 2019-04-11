//
//  CardDetectionView.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 22/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class CardDetectionView: PassThroughView {
    
    private var overlays = [CardOverlay]()
    private var nextOverlay = 0
    
    private var dotSize = CGFloat(48)
    private var programDots = [CGPoint]()
    
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
    
    private func drawNodes(_ nodes: [CardNodeProtocol]) {
        for node in nodes {
            let overlay = getCachedOverlay()
            overlay.setNode(node)
            
            if (!overlay.isDescendant(of: self)) {
                addSubview(overlay)
            }
        }
    }
    
    private func drawProgramNode(_ program: CardNodeProtocol?) {
        guard let node = program else { return }
        
        programDots.append(CGPoint(x: node.position.x, y: node.position.y))
        
        for child in node.children {
            drawProgramNode(child)
        }
    }
    
    func display(nodes: [CardNodeProtocol], program: CardNodeProtocol?) {
        nextOverlay = 0
        drawNodes(nodes)
        hideRemainingOverlays()
        
        programDots.removeAll()
        drawProgramNode(program)
        setNeedsDisplay()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result = super.point(inside: point, with: event)
        if !result {
            delegate?.cardView(didPressCard: nil)
        }
        return result
    }
    
    override func draw(_ rect: CGRect) {
        for dot in programDots {
            let circle = UIBezierPath(ovalIn: CGRect(
                x: dot.x - dotSize / 2,
                y: bounds.height - dot.y - dotSize / 2,
                width: dotSize,
                height: dotSize
            ))
            UIColor.blue.setFill()
            circle.fill()
        }
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
        self.image = UIImage(named: "DetectedCardBox")
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    func setNode(_ node: CardNodeProtocol) {
        let w = node.size.x
        let h = node.size.y
        let x = node.position.x - w / 2
        let y = Double(UIScreen.main.bounds.height) - node.position.y - h / 2
        
        frame = CGRect(x: x, y: y, width: w, height: h)
        card = node.card
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        if let card = card {
            delegate?.cardView(didPressCard: card)
        }
    }
}

protocol CardDetectionViewDelegate: class {
    func cardView(didPressCard card: Card?)
}
