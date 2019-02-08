//
//  CardNode.swift
//  VisionCardTest
//
//  Created by Kasper Schultz Davidsen on 2/1/19.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import SceneKit

protocol CardNode {
    var successors: [CardNode?] { get }
    var position: simd_double2 { get }
    
    func create(from node: ObservationNode, in graph: ObservationGraph) throws -> CardNode
    
    func getCard() -> Card
    //TODO: Pass state to make contidional logic possible
    func next() -> CardNode?
}
