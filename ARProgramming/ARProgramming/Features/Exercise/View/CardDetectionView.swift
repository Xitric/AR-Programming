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

class CardDetectionView: UIView {

    private var overlays = [CardOverlay]()
    private var nextOverlay = 0

    private var dotSizeFraction = 0.6
    private var program: CardNodeProtocol?

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

            if !overlay.isDescendant(of: self) {
                addSubview(overlay)
            }
        }
    }

    func display(nodes: [CardNodeProtocol], program: ProgramProtocol?) {
        nextOverlay = 0
        drawNodes(nodes)
        hideRemainingOverlays()

        self.program = program?.start
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
        guard let program = program else { return }

        UIColor.white.setFill()
        UIColor.white.setStroke()
        drawProgramNode(program)
    }

    private func drawProgramNode(_ node: CardNodeProtocol) {
        let dotSize = min(node.size.x, node.size.y) * dotSizeFraction

        let circle = UIBezierPath(ovalIn: CGRect(
            x: node.position.x - dotSize / 2,
            y: Double(bounds.height) - node.position.y - dotSize / 2,
            width: dotSize,
            height: dotSize
        ))
        circle.fill()

        for child in node.children {
            let line = UIBezierPath()
            line.move(to: CGPoint(x: node.position.x,
                                  y: Double(bounds.height) - node.position.y))
            line.addLine(to: CGPoint(x: child.position.x,
                                     y: Double(bounds.height) - child.position.y))
            line.lineWidth = 4
            line.stroke()
            drawProgramNode(child)
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
