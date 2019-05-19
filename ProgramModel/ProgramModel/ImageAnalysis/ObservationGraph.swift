//
//  ObservationGraph.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

class ObservationGraph {

    private static let maximumConnectionDistanceFraction = 1.3
    private static let maximumConnectionAngleMargin = 0.35

    private let observationSet: ObservationSet
    private var edges = [ObservationNode: [ObservationEdge]]()
    private var parents = [ObservationNode: ObservationNode]()
    private let nodeSize: Double
    private var maximumConnectionDistance: Double {
        return nodeSize * ObservationGraph.maximumConnectionDistanceFraction
    }

    init(observationSet: ObservationSet) {
        self.observationSet = observationSet
        self.nodeSize = observationSet.averageNodeDiagonal
    }

    func firstNode(withPayloadIn payloads: [String]) -> ObservationNode? {
        return observationSet.nodes.first { payloads.contains($0.payload) }
    }

    func nodes(near node: ObservationNode) -> [ObservationNode] {
        return observationSet.nodes.filter {
            $0 != node
                && !isConnected($0)
                && simd_distance(node.position, $0.position) < maximumConnectionDistance
        }.sorted {
            simd_distance(node.position, $0.position) < simd_distance(node.position, $1.position)
        }
    }

    func connect(from parent: ObservationNode, to child: ObservationNode, withAngle correctedAngle: Double) {
        if edges[parent] == nil {
            edges[parent] = [ObservationEdge]()
        }

        let edge = ObservationEdge(predecessor: parent, successor: child, connectionAngle: correctedAngle)
        edges[parent]!.append(edge)
        parents[child] = parent
    }

    func edge(from parent: ObservationNode, to child: ObservationNode) -> ObservationEdge? {
        return edges[parent]?.first { $0.successor == child }
    }

    func getSuccessor(by angle: Double, to node: ObservationNode) -> ObservationNode? {
        for successor in nodes(near: node) {
            if let parent = parents[node] {
                let inboundEdge = edge(from: parent, to: node)
                let outboundEdge = ObservationEdge(predecessor: node, successor: successor, connectionAngle: angle)

                if inboundEdge!.correctedAngleTo(edge: outboundEdge).isEqual(to: 0, margin: ObservationGraph.maximumConnectionAngleMargin) {
                    return successor
                }
            } else {
                return successor
            }
        }

        return nil
    }

    private func isConnected(_ node: ObservationNode) -> Bool {
        return parents[node] != nil || edges[node] != nil
    }
}
