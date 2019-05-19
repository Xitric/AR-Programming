//
//  ObservationSet.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import simd

struct ObservationSet {

    private static let duplicationDistanceFraction = 0.6
    private static let observationUncertaintyLimit = 15

    private(set) var nodes = [ObservationNode]()

    var averageNodeDiagonal: Double {
        guard nodes.count > 0 else {
            return 0
        }

        let accumulatedDiagonals = nodes.reduce(0) { $0 + $1.diagonal}
        return accumulatedDiagonals / Double(nodes.count)
    }

    mutating func add(_ node: ObservationNode) {
        for (i, other) in nodes.enumerated() {
            if isNode(node, duplicationOf: other) {
                nodes[i] = node
                return
            }
        }

        nodes.append(node)
    }

    mutating func markIteration() {
        for i in 0 ..< nodes.count {
            nodes[i].uncertainty = nodes[i].uncertainty + 1
        }

        nodes = nodes.filter { $0.uncertainty < ObservationSet.observationUncertaintyLimit }
    }

    private func isNode(_ node: ObservationNode, duplicationOf other: ObservationNode) -> Bool {
        if node.payload == other.payload {
            let allowableDistance = (node.width/2 + other.width/2) * ObservationSet.duplicationDistanceFraction

            return simd_distance(node.position, other.position) < allowableDistance
        }

        return false
    }
}
