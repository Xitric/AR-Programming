//
//  ProgramView.swift
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 26/03/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation

class ProgramView: UIView {
    
    private static let scale = CGFloat(80)
    
    private var nodesToDraw = [CardDrawable]()
    private var images = [String:UIImage]()
    
    var program: Program? {
        didSet {
            resetProgram()
        }
    }
    
    //TODO: Remove this when done testing
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
//        let start = SuccessorCardNode(card: StartCard(), angles: [0])
//        let move1 = SuccessorCardNode(card: MoveCard(), angles: [0])
//        let right = SuccessorCardNode(card: RightCard(), angles: [0])
//        let move2 = SuccessorCardNode(card: MoveCard(), angles: [0])
        
//        start.successors.append(move1)
//        move1.parent = start
//        
//        move1.successors.append(right)
//        right.parent = move1
//        
//        right.successors.append(move2)
//        move2.parent = right
//        program = Program(startNode: start)
    }
    
    private func resetProgram() {
        nodesToDraw.removeAll()
        images.removeAll()
        addNode(program?.start, atAngle: 0, fromParentPosition: CGPoint(x: -1, y: 0))
        wrapProgram()
        setNeedsDisplay()
    }
    
    private func addNode(_ node: CardNode?, atAngle angle: CGFloat, fromParentPosition parentPosition: CGPoint) {
        guard let node = node else {
            return
        }
        
        let imageName = node.card.internalName
        loadImage(withName: imageName)
        
        let denominator = abs(cos(angle)) + abs(sin(angle))
        let x = parentPosition.x + cos(angle) / denominator
        let y = parentPosition.y + sin(angle) / denominator
        
        let drawable = CardDrawable(imageName: imageName, x: x, y: y)
        nodesToDraw.append(drawable)
        
        for successor in node.successors {
            //TODO: Angle data from positions?
            //TODO: This position data is probably screwed up
            addNode(successor, atAngle: 0, fromParentPosition: CGPoint(x: x, y: y))
        }
    }
    
    private func loadImage(withName name: String) {
        if images[name] == nil {
            images[name] = UIImage(named: name)
            
        }
    }
    
    private func wrapProgram() {
        frame = CGRect(x: frame.minX, y: frame.minY, width: CGFloat(nodesToDraw.count) * ProgramView.scale, height: ProgramView.scale)
    }
    
    override func draw(_ rect: CGRect) {
        for drawable in nodesToDraw {
            let image = images[drawable.imageName]
            let imgRect = CGRect(x: drawable.x * ProgramView.scale,
                                 y: drawable.y * ProgramView.scale,
                                 width: ProgramView.scale,
                                 height: ProgramView.scale)
            image?.draw(in: imgRect)
        }
    }
}

private struct CardDrawable {
    let imageName: String
    let x: CGFloat
    let y: CGFloat
}
