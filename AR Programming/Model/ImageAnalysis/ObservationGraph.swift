//
//  ObservationGraph.swift
//  VisionCardTest
//
//  Created by user143563 on 2/1/19.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation
import simd

class ObservationGraph {
    
    private static let maximumAllowableDistanceFraction = 1.5
    private static let maximumAllowableAngleMargin = 0.35
    
    private let observationSet: ObservationSet
    private var edges = [ObservationNode:[ObservationEdge]]()
    private let scale: Double
    private var maximumAllowableDistance: Double {
        return scale * ObservationGraph.maximumAllowableDistanceFraction
    }
    
    init(observationSet: ObservationSet, with scale: Double) {
        self.observationSet = observationSet
        self.scale = scale
    }
    
    func firstObservation(with code: Int) -> ObservationNode? {
        for observation in observationSet.observations {
            if observation.code == code {
                return observation
            }
        }
        
        return nil
    }
    
    func observations(near observation: ObservationNode) -> [ObservationNode] {
        var observations = [ObservationNode]()
        
        for other in observationSet.observations {
            if other != observation
                && !isConnected(other)
                && simd_distance(observation.position, other.position) < maximumAllowableDistance {
                observations.append(other)
            }
        }
        
        return observations
    }
    
    func connect(from parent: ObservationNode, to child: ObservationNode, with correctedAngle: Double) {
        if edges[parent] == nil {
            edges[parent] = [ObservationEdge]()
        }
        
        let edge = ObservationEdge(predecessor: parent, successor: child, connectionAngle: correctedAngle)
        edges[parent]!.append(edge)
        child.parent = parent
    }
    
    func edge(from parent: ObservationNode, to child: ObservationNode) -> ObservationEdge? {
        if let edges = edges[parent] {
            for edge in edges {
                if edge.successor == child {
                    return edge
                }
            }
        }
        
        return nil
    }
    
    func getSuccessor(by angle: Double, to node: ObservationNode) -> ObservationNode? {
        for successor in observations(near: node) {
            if let parent = node.parent {
                let inboundEdge = edge(from: parent, to: node)
                let outboundEdge = ObservationEdge(predecessor: node, successor: successor, connectionAngle: angle)
                
                if inboundEdge!.correctedAngleTo(edge: outboundEdge).isEqual(to: 0, margin: ObservationGraph.maximumAllowableAngleMargin) {
                    return successor
                }
            } else {
                return successor
            }
        }
        
        return nil
    }
    
    private func isConnected(_ observation: ObservationNode) -> Bool {
        return observation.parent != nil || edges[observation] != nil
    }
}
