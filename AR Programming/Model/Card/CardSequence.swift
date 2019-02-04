//
//  CardSequence.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 17/10/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import CoreGraphics
import SceneKit

class CardSequence {
    
    private var sequence = [Card]()
    weak var delegate: CardSequenceProgressDelegate?
    
    init(cards: CardWorld, on surface: Plane) {
        let planes = cards.allPlanes()
        let projections = project(planes: planes, onto: surface)
        
        let regressionLine = RegressionLine(points: projections)
        let regressionDirection = regressionLine.direction.normalize()
        var distances = projections.map{$0.dot(with: regressionDirection)}
        
        let startIndex = planes.firstIndex(where: {cards.card(from: $0)?.name == "Start"})
        if let i = startIndex {
            sequence.append(cards.card(from: planes[i])!)
            distances = update(distances: distances, from: i)
            
            for _ in 0 ..< distances.count - 1 {
                let smallestIndex = indexOfSmallest(among: distances)
                if distances[smallestIndex] > 0.2 { //0.07
                    break;
                }
                
                sequence.append(cards.card(from: planes[smallestIndex])!)
                distances = update(distances: distances, from: smallestIndex)
            }
        }
    }
    
    private func update(distances: [Float], from index: Int) -> [Float] {
        let referenceValue = distances[index]
        var newDistances = distances.map{$0 - referenceValue}
        newDistances[index] = Float.infinity
        return newDistances
    }
    
    private func indexOfSmallest(among distances: [Float]) -> Int {
        return distances.firstIndex(of: distances.min()!)!
    }
    
    private func project(planes: [Plane], onto surface: Plane) -> [Vector2] {
        return planes.map{project(plane: $0, onto: surface)}
    }
    
    private func project(plane: Plane, onto surface: Plane) -> Vector2 {
        return surface.project(point: plane.center)
    }
    
    public func run(on animatable: AnimatableNode) {
        let remainingSeuence = [Card](sequence)
        performNextAction(in: remainingSeuence, on: animatable)
    }
    
    private func performNextAction(in remainingSequence: [Card], on animatable: AnimatableNode) {
        if let card = remainingSequence.first {
            if let action = card.command?.execute(modelIn3D: animatable) {
                animatable.model.runAction(action) {
                    self.delegate?.cardSequence(robot: animatable, executed: card)
                    self.performNextAction(in: [Card](remainingSequence.dropFirst()), on: animatable)
                }
            } else {
                self.performNextAction(in: [Card](remainingSequence.dropFirst()), on: animatable)
            }
        } else {
            delegate?.cardSequenceFinished(robot: animatable)
        }
    }
    
    private struct PlaneCollection {
        var startPlane: Plane
        var planes: [Plane]
    }
}
