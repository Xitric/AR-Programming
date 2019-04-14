//
//  FunctionView.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import ProgramModel

class FunctionView: UIView {
    
    private var nodesToDraw = [CardDrawable]()
    private var images = [String:UIImage]()
    private var xOffset = CGFloat(0)
    private var yOffset = CGFloat(0)
    
    var scale = CGFloat(60)
    var program: ProgramProtocol? {
        didSet {
            resetProgram()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return frame.size
    }
    
    private func resetProgram() {
        nodesToDraw.removeAll()
        images.removeAll()
        
        addNode(program?.start, parentPosition: CGPoint(x: -1, y: 0))
        wrapProgram()
    }
    
    private func addNode(_ node: CardNodeProtocol?, parentPosition: CGPoint) {
        guard let node = node else {
            return
        }
        
        let imageName = node.card.internalName
        loadImage(withName: imageName)
        
        let angle = CGFloat(node.entryAngle)
        let denominator = abs(cos(angle)) + abs(sin(angle))
        let x = parentPosition.x + cos(angle) / denominator
        let y = parentPosition.y - sin(angle) / denominator
        
        let drawable = CardDrawable(imageName: imageName, x: x, y: y)
        nodesToDraw.append(drawable)
        
        for child in node.children {
            addNode(child, parentPosition: CGPoint(x: x, y: y))
        }
    }
    
    private func loadImage(withName name: String) {
        if images[name] == nil {
            images[name] = UIImage(named: name)
        }
    }
    
    private func wrapProgram() {
        //Find minimum and maximum extent on both axes
        var min = CGPoint(x: 0, y: 0)
        var max = CGPoint(x: 0, y: 0)
        
        for drawable in nodesToDraw {
            let drawableMin = CGPoint(x: drawable.x, y: drawable.y)
            let drawableMax = CGPoint(x: drawable.x + 1, y: drawable.y + 1)
            
            if drawableMin.x < min.x {
                min.x = drawableMin.x
            }
            if drawableMax.x > max.x {
                max.x = drawableMax.x
            }
            
            if drawableMin.y < min.y {
                min.y = drawableMin.y
            }
            if drawableMax.y > max.y {
                max.y = drawableMax.y
            }
        }
        
        xOffset = min.x
        yOffset = min.y
        
        frame = CGRect(x: frame.minX, y: frame.minY, width: (max.x - min.x) * scale, height: (max.y - min.y) * scale)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for drawable in nodesToDraw {
            let image = images[drawable.imageName]
            let imgRect = CGRect(x: (drawable.x - xOffset) * scale,
                                 y: (drawable.y - yOffset) * scale,
                                 width: scale,
                                 height: scale)
            image?.draw(in: imgRect)
        }
    }
}

private struct CardDrawable {
    let imageName: String
    let x: CGFloat
    let y: CGFloat
}
