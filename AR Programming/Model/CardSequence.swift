//
//  CardSequence.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import CoreGraphics

class CardSequence {
    
    private var sequence = [Card]()
    
    init(cards: CardWorld, on surface: Plane) {
        if let splitPlanes = splitOnStartCard(cards: cards) {
            let startProjection = project(plane: splitPlanes.startPlane, onto: surface)
            let projections = project(planes: splitPlanes.planes, onto: surface)
            
            //Find a line that best describes the way the cards are laid out
            let line = RegressionLine(points: projections + [startProjection])
            
            //Calculate the projected points' distances from the starting point along the regression line
            var dx = Float(1)
            var dy = line.slope! //TODO: Why is explicit unwrapping necessary here?
            let len = sqrt(pow(dx, 2) + pow(dy, 2))
            
            dx = dx / len
            dy = dy / len
            
            let startPosition = Float(startProjection.x) * dx + Float(startProjection.y) * dy
            var positions = projections.map{Float($0.x) * dx + Float($0.y) * dy - startPosition}
            
            //Find sequence
            //TODO
        }
    }
    
    private func splitOnStartCard(cards: CardWorld) -> PlaneCollection? {
        let allPlanes = cards.allPlanes()
        var planes = [Plane]()
        var startPlane: Plane?
        
        for plane in allPlanes {
            if cards.card(from: plane)?.name == "Start" {
                startPlane = plane
            } else {
                planes.append(plane)
            }
        }
        
        if let start = startPlane {
            return PlaneCollection(startPlane: start, planes: planes)
        }
        
        return nil
    }
    
    private func project(planes: [Plane], onto surface: Plane) -> [CGPoint] {
        return planes.map{project(plane: $0, onto: surface)}
    }
    
    private func project(plane: Plane, onto surface: Plane) -> CGPoint {
        return surface.project(point: plane.center)
    }
    
    public func run(on node: AnimatableNode) {
        for card in sequence {
            card.command?.execute(modelIn3D: node)
        }
    }
    
    private struct PlaneCollection {
        var startPlane: Plane
        var planes: [Plane]
    }
}
